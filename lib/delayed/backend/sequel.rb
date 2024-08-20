# frozen_string_literal: true

require 'delayed_job'
require 'fugit'
require 'fugit/cron'
require 'sequel'

module Delayed
  module Backend
    module Sequel
      # Delayed Job Sequel Backend.
      class Job < ::Sequel::Model # rubocop:disable Metrics/ClassLength
        include Delayed::Backend::Base

        alias save! save
        alias update_attributes update

        dataset_module do
          # Finds jobs that are ready to be run.
          #
          # @param worker [String] The name of the worker trying to find a job.
          # @param max_run_time [Integer] The maximum time a job is allowed to
          #   run.
          # @return [Sequel::Dataset] The dataset of jobs that are ready to be
          #   run.
          def ready_to_run(worker, max_run_time)
            db_time_now = model.db_time_now
            filter do
              (
                ((run_at <= db_time_now) &
                  ::Sequel.expr(locked_at: nil)) |
                  (::Sequel.expr(locked_at: ..(db_time_now - max_run_time))) |
                  { locked_by: worker }
              ) & { failed_at: nil }
            end
          end

          # Orders jobs by priority and their run time.
          #
          # @return [Sequel::Dataset] The dataset of jobs ordered by priority.
          def by_priority
            order(
              ::Sequel.expr(:priority).asc,
              ::Sequel.expr(:run_at).asc
            )
          end
        end

        # Before saving, make sure the job has been scheduled.
        def before_save
          set_next_run_at
          set_default_run_at
          super
        end

        # Don't destroy recurring jobs that need to be rescheduled.
        def destroy
          if !payload_object.respond_to?(:reschedule_instead_of_destroy) ||
             !(cron && payload_object.reschedule_instead_of_destroy)
            return super
          end

          schedule_next_run
        end

        # Schedules the next run for a recurring job and unlock it.
        def schedule_next_run
          self.attempts += 1
          unlock
          set_next_run_at
          save!
        end

        # Scheduled non-recurring jobs to run now.
        def set_next_run_at
          return unless cron

          self.run_at = Fugit::Cron.do_parse(cron).next_time(now).to_local_time
        end

        # Gain an exclusive lock on the job so that it doesn't get picked up by
        # another worker.
        #
        # @param max_run_time [Integer] the maximum time a job is allowed to run
        #   before it is considered dead.
        # @param worker [String] the name of the worker that is trying to lock
        #   this job.
        def lock_exclusively!(max_run_time, worker)
          locked = regain_lock(worker) || claim_lock(worker, max_run_time)

          reload if locked
          locked
        end

        class << self
          def db_time_now
            Time.now
          end

          # Database connections don't like being forked.
          def before_fork
            ::Sequel::DATABASES.each(&:disconnect)
          end

          # Reconnect to the database after forking.
          def after_fork
            ::Sequel::DATABASES.each { |d| d.connect(d.uri) }
          end

          # Clear all locks from this worker.
          #
          # @param worker [String] the name of the worker to clear the locks
          #   for.
          def clear_locks!(worker)
            Job.where(locked_by: worker)
               .update(locked_at: nil, locked_by: nil)
          end

          # Deletes all jobs in the queue.
          def delete_all
            dataset.delete
          end

          # Find jobs that are available to be run.
          #
          # @param worker [String] The name of the worker trying to find a job.
          # @param limit [Integer] The maximum number of jobs to find.
          # @param max_run_time [Integer] The maximum time a job is allowed to
          #   run.
          # @return [Sequel::Dataset] The jobs that are available to be run.
          def find_available(worker, limit = 5, max_run_time = Worker.max_run_time)
            ds = ready_to_run(worker, max_run_time)
            ds = ds.where(priority: Worker.min_priority..) if Worker.min_priority
            ds = ds.where(priority: ..Worker.max_priority) if Worker.max_priority
            ds = ds.where(queue: Worker.queues) if Worker.queues.any?

            ds.limit(limit).by_priority
          end

          # Reserves a job for this worker.
          #
          # @param worker [Delayed::Worker] The worker that is trying to reserve
          #   a job.
          # @param max_run_time [Integer] The maximum time a job is allowed to
          #   run.
          # @return [Job] The job that was reserved.
          def reserve(worker, max_run_time = Worker.max_run_time)
            lock_with_for_update(
              find_available(worker, 1, max_run_time),
              worker
            )
          end

          # Locks an individual job for a worker.
          #
          # This method uses a database lock to prevent other workers from
          # claiming this job.
          #
          # @param records [Sequel::Dataset] The dataset to lock a job from.
          # @param worker [Delayed::Worker] The worker that is trying to lock
          #   the job.
          # @return [Job] The job that was locked.
          def lock_with_for_update(records, worker)
            records = records.for_update
            db.transaction do
              job = records.first
              if job
                job.locked_at = db_time_now
                job.locked_by = worker
                job.save(raise_on_failure: true)
                job
              end
            end
          end
        end

        private

        def now
          @now ||= self.class.db_time_now
        end

        # Regain the lock on a job that was locked by a worker that died.
        #
        # @param worker [String] the name of the worker trying to lock the job.
        # @return [Boolean] Whether or not the lock was obtained.
        def regain_lock(worker)
          return false unless locked_by == worker

          Job.where(id:, locked_by: worker).update(locked_at: now) == 1
        end

        # Claim a lock on the job.
        #
        # @param worker [String] the name of the worker trying to lock the job.
        # @param max_run_time [Integer] the maximum time a job is allowed to run
        #   before it is considered dead.
        # @return [Boolean] Whether or not the lock was obtained.
        def claim_lock(worker, max_run_time)
          now = self.class.db_time_now
          Job.where(id:, run_at: ..now)
             .where do
               ::Sequel.expr(locked_at: nil) |
                 ::Sequel.expr(locked_at: ..(now - max_run_time))
             end
             .update(locked_at: now, locked_by: worker) == 1
        end
      end
    end
  end
end

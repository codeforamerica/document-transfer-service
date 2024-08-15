# frozen_string_literal: true

require 'delayed_job'
require 'fugit'
require 'fugit/cron'
require 'sequel'

module Delayed
  module Backend
    module Sequel
      # Delayed Job Sequel Backend.
      class Job < ::Sequel::Model
        include Delayed::Backend::Base

        alias save! save
        alias update_attributes update

        # Before saving, make sure the job has been scheduled.
        def before_save
          set_next_run_at
          set_default_run_at
          super
        end

        # Don't destroy recurring jobs that need to be rescheduled.
        def destroy
          return super unless payload_object.schedule_instead_of_destroy && cron

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

        def name
          x = super
          x + " (#{pk})"
        end

        # Gain an exclusive lock on the job so that it doesn't get picked up by
        # another worker.
        #
        # @param [Integer] max_run_time the maximum time a job is allowed to run
        #   before it is considered dead.
        # @param [String] worker the name of the worker that is trying to lock
        #   this job.
        def lock_exclusively!(max_run_time, worker)
          locked = regain_lock(worker) || claim_lock(worker, max_run_time)

          reload if locked
          locked
        end

        class << self
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
          # @param [String] worker the name of the worker to clear the locks
          #   for.
          def clear_locks!(worker)
            Job.where(locked_by: worker)
               .update(locked_at: nil, locked_by: nil)
          end

          # Find jobs that are available to be run.
          #
          # @param [String] _worker The name of the worker trying to find a job.
          # @param [Integer] limit The maximum number of jobs to find.
          # @param [Integer] max_run_time The maximum time a job is allowed to
          #   run.
          # @return [Array<Job>] The jobs that are available to be run.
          # rubocop:disable Metrics/AbcSize
          def find_available(_worker, limit = 5, max_run_time = Worker.max_run_time)
            query = Job.where(run_at: ..Time.now)
                       .where { ::Sequel[locked_at: nil] | ::Sequel[locked_at: ..(Time.now - max_run_time)] }
                       .where(failed_at: nil)
            query = query.where(priority: Worker.min_priority..) if Worker.min_priority
            query = query.where(priority: ..Worker.max_priority) if Worker.max_priority
            query = query.where(queue: Worker.queues) if Worker.queues.any?

            query.limit(limit).order(:priority).order_append(:run_at).all
          end
          # rubocop:enable Metrics/AbcSize
        end

        private

        def now
          @now ||= Time.now
        end

        # Regain the lock on a job that was locked by a worker that died.
        #
        # @param [String] worker the name of the worker trying to lock the job.
        # @return [Boolean] Whether or not the lock was obtained.
        def regain_lock(worker)
          return false unless locked_by == worker

          Job.where(id:, locked_by: worker).update(locked_at: now) == 1
        end

        # Claim a lock on the job.
        #
        # @param [String] worker the name of the worker trying to lock the job.
        # @param [Integer] max_run_time the maximum time a job is allowed to run
        #   before it is considered dead.
        # @return [Boolean] Whether or not the lock was obtained.
        def claim_lock(worker, max_run_time)
          Job.where(id:, run_at: ..now)
             .where { (locked_at.nil?) | (locked_at < now - max_run_time) }
             .update(locked_at: now, locked_by: worker) == 1
        end
      end
    end
  end
end

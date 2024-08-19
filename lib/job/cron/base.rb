# frozen_string_literal: true

require_relative '../base'

module DocumentTransfer
  module Job
    module Cron
      # Base class for recurring cron jobs.
      #
      # @abstract Subclass and implement {#perform} to define a cron job.
      class Base < Base
        class_attribute :cron_expression

        attr_accessor :schedule_instead_of_destroy

        def queue
          return if self.class.scheduled?

          Delayed::Job.enqueue(self, cron: cron_expression)
        end

        def after
          self.schedule_instead_of_destroy = true
        end

        class << self
          # Schedule the job to run.
          def schedule
            new.queue unless scheduled?
          end

          # Remove the job from the schedule.
          def remove
            delayed_job.destroy if scheduled?
          end

          # Reschedule the job.
          def reschedule
            remove
            schedule
          end

          # Whether the job is scheduled.
          #
          # @return [Boolean]
          def scheduled?
            !delayed_job.nil?
          end

          # Return the first instance of this job in the queue.
          #
          # @return [Delayed::Job, nil]
          def delayed_job
            Delayed::Job.where(Sequel.like(:handler, "%ruby/object:#{name}%")).first
          end
        end
      end
    end
  end
end

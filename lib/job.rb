# frozen_string_literal: true

module DocumentTransfer
  # Top-level module for background jobs.
  module Job
    # Load all jobs into memory so that they don't need to be required
    # individually.
    def self.load
      require_relative 'job/cron/expire_key'
    end

    # Ensure that all cron jobs are scheduled to be run.
    #
    # @return [Boolean] Reschedules all jobs.
    # @return [Integer] The number of jobs scheduled.
    def self.schedule(force: false)
      self.load

      Cron.constants.select do |klass|
        job = Cron.const_get(klass)
        next unless job.respond_to?(:reschedule) && job.cron_expression

        force ? job.reschedule : job.schedule
      end.length
    end
  end
end

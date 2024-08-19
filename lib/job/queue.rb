# frozen_string_literal: true

require 'delayed_job'

module DocumentTransfer
  module Job
    # Interface for the job queue.
    class Queue
      # Get statistics about the job queue.
      #
      # @return [Hash{Symbol => Integer}]
      def stats
        {
          recurring:,
          oldest:,
          running:,
          total:,
          waiting:
        }
      end

      # Currently scheduled recurring jobs.
      #
      # @return [Integer]
      def recurring
        Delayed::Job.exclude(cron: nil).count
      end

      # Age, in seconds, of the oldest non-recurring job in the queue.
      #
      # @return [Float]
      def oldest
        job = Delayed::Job.where(cron: nil, locked_at: nil).order(:run_at).first
        return 0 unless job

        (Time.now - job.run_at).seconds
      end

      # Number of jobs currently being worked.
      #
      # @return [Integer]
      def running
        Delayed::Job.exclude(locked_at: nil).count
      end

      # Total number of jobs in the queue.
      #
      # @return [Integer]
      def total
        Delayed::Job.count
      end

      # Number of jobs waiting to be worked.
      #
      # @return [Integer]
      def waiting
        Delayed::Job.where(locked_at: nil)
                    .where { Sequel[cron: nil] | Sequel[run_at: ..Time.now] }
                    .count
      end
    end
  end
end

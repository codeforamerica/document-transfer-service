# frozen_string_literal: true

require 'delayed_job'
require 'statsd-instrument'

require_relative '../util/measure'

module DocumentTransfer
  module Job
    # Base class for background jobs.
    #
    # @abstract Subclass and override {#perform} to implement a job.
    class Base
      include Util::Measure

      DEFAULT_TAGS = %W[
        service:#{DocumentTransfer::NAME}
        version:#{DocumentTransfer::VERSION}
        environment:#{ENV.fetch('RACK_ENV', 'development')}
      ].freeze

      attr_writer :logger

      # Initialize the job.
      #
      # @param payload [Hash] The payload required to process the job.
      # @return [self]
      def initialize(payload = {})
        @payload = payload
      end

      # The logger for the job.
      #
      # @return [SemanticLogger::Logger]
      def logger
        @logger ||= SemanticLogger[self.class]
      end

      # Queue the job for processing.
      def queue
        Delayed::Job.enqueue(self)
      end

      # Perform the job.
      #
      # @return [void]
      #
      # @raise [NotImplementedError] If the method is not implemented.
      def perform
        raise NotImplementedError
      end

      # Callback before the job is enqueued.
      #
      # Increment the count of jobs queued.
      def enqueue
        StatsD.increment('jobs.queued.count', tags:)
      end

      # Callback before the job is executed.
      #
      # Record the start time of the job.
      def before
        @start = clock_time
      end

      # Callback after the job is executed.
      #
      # Record the duration of the job.
      def after
        StatsD.measure('jobs.completed.duration', clock_time - @start, tags:)
      end

      private

      # The name of this job to use for statistics.
      #
      # By default, we use the class name with the first 2 module names
      # ("DocumentTransfer::Job") removed and the remaining parts joined with a
      # ".". We then convert the name to lower dash case (e.g. "FooBar" becomes
      # "foo-bar").
      #
      # @return [String]
      def stat_name
        self.class.name.split('::')[2..].join('.')
            .gsub(/(?<=[a-z])\B(?=[A-Z])/, '-').downcase
      end

      # The tags to use for statistics.
      #
      # @return [Array<String>]
      def tags
        DEFAULT_TAGS + ["job:#{stat_name}"]
      end

      class << self
        # Enqueue a new job for processing.
        #
        # @param payload [Hash] The payload required to process the job.
        # @return [DocumentTransfer::Job::Base] The job instance.
        def queue(payload = {})
          new(payload).tap(&:queue)
        end
      end
    end
  end
end

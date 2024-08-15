# frozen_string_literal: true

require 'statsd-instrument'

require_relative 'base'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap the worker.
      class Worker < Base
        DEFAULT_TAGS = %W[
          service:#{DocumentTransfer::NAME}
          version:#{DocumentTransfer::VERSION}
          environment:#{ENV.fetch('RACK_ENV', 'development')}
        ].freeze

        # Create a separate thread to monitor the queue.
        def bootstrap
          Thread.abort_on_exception = true
          Thread.new do
            require_relative '../../job/queue'

            queue = DocumentTransfer::Job::Queue.new
            loop do
              sleep config.queue_stats_interval
              report(queue)
            end
          end
        end

        private

        # Report stats to StatsD.
        #
        # @param queue [DocumentTransfer::Job::Queue] Queue to report stats for.
        # @return [void]
        def report(queue)
          stats = queue.stats
          StatsD.measure('jobs.queue.oldest.age', stats.delete(:oldest),
                         tags: DEFAULT_TAGS)
          stats.each do |stat, value|
            StatsD.measure("jobs.queue.size.#{stat}", value, tags: DEFAULT_TAGS)
          end
        end
      end
    end
  end
end

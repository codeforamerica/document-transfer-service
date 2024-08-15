# frozen_string_literal: true

module DocumentTransfer
  module Util
    # Utility methods for measuring duration.
    module Measure
      def clock_time
        Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

      def measure(&block)
        start = clock_time
        response = yield block
        finish = clock_time

        [response, (finish - start)]
      end
    end
  end
end

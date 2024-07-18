# frozen_string_literal: true

module DocumentTransfer
  module API
    # Middleware for the API.
    module Middleware
      # Load all middleware and return them as an array that can be passed to
      # Rack.
      #
      # @return [Array<Class>] The middleware classes, ordered as expected.
      def self.load
        require_relative 'middleware/auth_key'
        require_relative 'middleware/correlation_id'
        require_relative 'middleware/instrument'
        require_relative 'middleware/request_id'
        require_relative 'middleware/request_logging'

        [
          RequestId,
          CorrelationId,
          Instrument,
          RequestLogging,
          AuthKey
        ]
      end
    end
  end
end

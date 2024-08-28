# frozen_string_literal: true

module DocumentTransfer
  module API
    module Middleware
      # Rack middleware that adds a correlation id to requests that don't
      # include one.
      #
      # This middleware must be loaded before any middleware that may make use
      # of the correlation id (such as logging).
      class CorrelationId
        HEADER = 'x-correlation-id'
        KEY = 'HTTP_X_CORRELATION_ID'

        # Initialize the middleware
        #
        # @param app [Rack::Events] The Rack application.
        def initialize(app)
          @app = app
        end

        # Ensure that the request has a correlation id.
        #
        # @param env [Hash] The environment hash.
        # @return [Array<Integer, Rack::Headers, Rack::BodyProxy>] The response
        #   for the request.
        def call(env)
          # Prefer the existing correlation id, if it exists.
          correlation_id = env.fetch(KEY, generate)
          env[KEY] ||= correlation_id

          # Add the correlation id to to the response headers.
          status, headers, body = @app.call(env)
          headers[HEADER] = correlation_id

          [status, headers, body]
        end

        private

        # Generates a random correlation id.
        #
        # @return [String]
        def generate
          SecureRandom.uuid
        end
      end
    end
  end
end

# frozen_string_literal: true

module DocumentTransfer
  module API
    module Middleware
      # Rack middleware that adds a request id to requests that don't include
      # one.
      #
      # This middleware must be loaded before any middleware that may make use
      # of the request id (such as logging).
      class RequestId
        HEADER = 'x-request-id'
        KEY = 'HTTP_X_REQUEST_ID'

        # Initialize the middleware
        #
        # @param [Rack::Events] app The Rack application.
        def initialize(app)
          @app = app
        end

        # Ensure that the request has a request id.
        #
        # @param [Hash] env The environment hash.
        # @return [Array<Integer, Rack::Headers, Rack::BodyProxy] The response
        #   for the request.
        def call(env)
          # Prefer the existing request id, if it exists.
          request_id = env.fetch(KEY, generate)
          env[KEY] ||= request_id

          # Add the request id to to the response headers.
          status, headers, body = @app.call(env)
          headers[HEADER] = request_id

          [status, headers, body]
        end

        private

        # Generates a random request id.
        #
        # @return [String]
        def generate
          SecureRandom.uuid
        end
      end
    end
  end
end

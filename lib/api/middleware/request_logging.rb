# frozen_string_literal: true

require 'semantic_logger'

require_relative 'request_id'
require_relative '../../util/measure'

module DocumentTransfer
  module API
    module Middleware
      # Rack middleware to log all requests.
      #
      # Uses a semantic logger to log requests in JSON format.
      class RequestLogging
        include DocumentTransfer::Util::Measure
        include SemanticLogger::Loggable

        DEFAULT_TAGS = {
          service: 'document-transfer-service',
          version: DocumentTransfer::VERSION,
          environment: ENV.fetch('RACK_ENV', 'development')
        }.freeze

        # Initialize the middleware
        #
        # @param app [Rack::Events] The Rack application.
        def initialize(app)
          @app = app
        end

        # Log the request and response details.
        #
        # @param env [Hash] The environment hash.
        # @return [Array<Integer, Rack::Headers, Rack::BodyProxy>] The response
        #   for the request.
        def call(env)
          response, time = measure { @app.call(env) }
          log(response[0], response[1], env, time)
          response
        end

        private

        # Fetches the content length for the response.
        #
        # @param headers [Rack::Headers] The response headers.
        def content_length(headers)
          headers[Rack::CONTENT_LENGTH] || '-'
        end

        # Fetches the query string from the request.
        #
        # @param request [Rack::Request] The request.
        def query_string(request)
          request.query_string.empty? ? '' : "?#{request.query_string}"
        end

        # Fetches the request id from the environment.
        #
        # The request id may not exist in the request parameters if it wasn't
        # included in the incoming request. Checking the environment hash
        # instead ensures we get the request id if it was added by our
        # middleware.
        #
        # @param env [Hash] The environment hash.
        def request_id(env)
          env.fetch(RequestId::KEY, '-')
        end

        # Log the request details.
        #
        # @param status [Integer] The HTTP status code.
        # @param headers [Rack::Headers] The response headers.
        # @param env [Hash] The environment hash.
        # @param duration [Float] The duration of the request.
        def log(status, headers, env, duration)
          SemanticLogger.push_named_tags(DEFAULT_TAGS)
          logger.info(
            message: 'Request received',
            duration:,
            payload: payload(status, headers, env, duration)
          )
        end

        # Builds the payload for the log message.
        #
        # @param status [Integer] The HTTP status code.
        # @param headers [Rack::Headers] The response headers.
        # @param env [Hash] The environment hash.
        # @param duration [Float] The duration of the request.
        # @return [Hash]
        def payload(status, headers, env, duration)
          request = Rack::Request.new(env)
          {
            ip: request.ip || '-',
            remote_user: request.get_header('REMOTE_USER') || '-',
            time: Time.now.strftime('%d/%b/%Y:%H:%M:%S %z'),
            request_method: request.request_method,
            script_name: request.script_name,
            path_info: request.path_info,
            query_string: query_string(request),
            server_protocol: request.get_header(Rack::SERVER_PROTOCOL),
            status: status.to_s[0..3],
            duration:,
            content_length: content_length(headers),
            request_id: request_id(env)
          }
        end
      end
    end
  end
end

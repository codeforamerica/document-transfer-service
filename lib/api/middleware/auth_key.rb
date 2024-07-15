# frozen_string_literal: true

require_relative '../../model/auth_key'

module DocumentTransfer
  module API
    module Middleware
      # Provides auth key (or bearer token) based authentication for the API.
      class AuthKey
        AUTH_HEADER_KEY = 'HTTP_AUTHORIZATION'
        AUTH_PATTERN = /^Bearer realm="(?<realm>.+)" (?<key>.+)$/

        # Paths to be excluded from authentication.
        EXCLUDED_PATHS = %w[/health].freeze

        def initialize(app)
          @app = app
        end

        def call(env)
          request = Rack::Request.new(env)

          authorize(request) || @app.call(env)
        end

        private

        # Attempts to authorize the request based on the provided auth key.
        #
        # @param request [Rack::Request] The request to authorize.
        # @return [nil, Array] If the request is authorized, nil is returned.
        def authorize(request)
          return if excluded?(request)

          authorization = request.get_header('HTTP_AUTHORIZATION')
          matches = AUTH_PATTERN.match(authorization)

          return no_auth unless matches
          return bad_auth unless authorized?(matches[:realm], matches[:key])

          # Return nil to indicate that the request is authorized, and allow
          # the caller to continue processing.
          nil
        end

        # Determines if the provided key is valid.
        #
        # @param realm [String] The realm to validate the key against. This
        #   should be the id of a consumer.
        # @param key [String] The key to validate.
        # @return [Boolean]
        def authorized?(realm, key)
          keys = Model::Consumer[realm]&.active_keys || []
          keys.each do |k|
            return true if k == key
          end

          false
        end

        # Determines if the request should be excluded from authentication.
        #
        # @param request [Rack::Request] The request to check.
        # @return [Boolean]
        def excluded?(request)
          EXCLUDED_PATHS.include?(request.path)
        end

        # Returns a 401 response indicating that authentication is required.
        #
        # @return [Array]
        def no_auth
          not_authorized(:token_required, 'Authentication required')
        end

        # Returns a 401 response indicating that the provided auth key is
        # invalid.
        #
        # @return [Array]
        def bad_auth
          not_authorized(:invalid_token, 'Authentication failed')
        end

        # Returns a 401 response indicating that the request is not authorized.
        #
        # @param reason [Symbol] The reason for the failure.
        # @param message [String] A message to include in the response.
        # @return [Array]
        def not_authorized(reason, message)
          [
            401,
            {
              'content-type' => 'application/json',
              'www-authenticate' => "Bearer realm=\"#{reason}\""
            },
            [{ status: 'error', message: }.to_json]
          ]
        end
      end
    end
  end
end

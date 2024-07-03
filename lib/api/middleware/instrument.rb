# frozen_string_literal: true

require 'statsd-instrument'

require_relative '../util/measure'

module DocumentTransfer
  module API
    module Middleware
      # Rack middleware that provides instrumentation for endpoints.
      class Instrument
        include DocumentTransfer::Util::Measure

        DEFAULT_TAGS = [
          'service:document-transfer-service',
          "version:#{DocumentTransfer::VERSION}",
          "environment:#{ENV.fetch('RACK_ENV', 'development')}"
        ].freeze

        # Initialize the middleware
        #
        # @param [Rack::Events] app The Rack application.
        def initialize(app)
          @app = app
        end

        # Measure the duration of the request.
        #
        # We could measure the duration in a block to StatsD.measure, but we
        # don't have access to the grape endpoint until after it has been
        # executed. Additionally, we want to include the HTTP status code in the
        # tags.
        #
        # @param [Hash] env The environment hash.
        # @return [Array<Integer, Rack::Headers, Rack::BodyProxy] The response
        #   for the request.
        def call(env)
          response, duration = measure { @app.call(env) }

          # Increment the number of requests to this endpoint, and add a measure
          # of its duration.
          tags = tags(env['api.endpoint'], status: response[0])
          StatsD.increment("#{stat_name(env['api.endpoint'])}.requests", tags:)
          StatsD.measure("#{stat_name(env['api.endpoint'])}.duration",
                         duration, tags:)

          response
        end

        private

        # Fetches the base name for our stats.
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @return [String]
        def stat_name(endpoint)
          # If the stat hasn't been explicitly set, we'll use the namespace and
          # path of the endpoint.
          name = endpoint.options[:route_options][:stat_name] ||
                 build_stat_name(endpoint)

          "endpoint.#{name}"
        end

        # Builds the stat name for an endpoint that doesn't have one explicitly
        # defined.
        #
        # We use the name space and path of the endpoint, stripping any "/" and
        # joining the parts with a ".".
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @return [String]
        def build_stat_name(endpoint)
          parts = (endpoint.namespace.split('/') +
                   endpoint.options[:path])
          parts.reject! { |part| part.empty? || part == '/' }
          parts.join('.')
        end

        # Builds an array of tags to include with our stats.
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @param [Integer] status The HTTP status code.
        # @return [Array<String>]
        def tags(endpoint, status: nil)
          tags = DEFAULT_TAGS + [
            "method:#{endpoint.options[:method].first}"
          ]
          tags << "status:#{status}" unless status.nil?

          tags
        end
      end
    end
  end
end

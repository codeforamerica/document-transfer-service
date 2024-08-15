# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'statsd-instrument'

require_relative 'correlation_id'
require_relative 'request_id'
require_relative '../../util/measure'

module DocumentTransfer
  module API
    module Middleware
      # Rack middleware that provides instrumentation for endpoints.
      class Instrument
        include DocumentTransfer::Util::Measure

        DEFAULT_TAGS = %W[
          service:#{DocumentTransfer::NAME}
          version:#{DocumentTransfer::VERSION}
          environment:#{ENV.fetch('RACK_ENV', 'development')}
        ].freeze

        # Initialize the middleware
        #
        # @param [Rack::Events] app The Rack application.
        def initialize(app)
          @app = app
        end

        # Record and measure details about the request.
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
          telemetry_attributes(env)
          response, duration = measure { @app.call(env) }

          # If this wasn't an endpoint, we don't have any stats to record.
          return response unless env.key?('api.endpoint')

          # Increment the number of requests to this endpoint, and add a measure
          # of its duration.
          tags = tags(env['api.endpoint'], status: response[0])
          StatsD.increment('endpoint.requests.count', tags:)
          StatsD.measure('endpoint.requests.duration', duration, tags:)

          response
        end

        private

        # Fetches the name for the endpoint we're instrumenting.
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @return [String]
        def endpoint_name(endpoint)
          endpoint.options[:route_options][:endpoint_name] ||
            build_endpoint_name(endpoint)
        end

        # Builds the name for an endpoint that doesn't have one explicitly
        # defined.
        #
        # We use the namespace and path of the endpoint, stripping any "/" and
        # joining the parts with a ".".
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @return [String]
        def build_endpoint_name(endpoint)
          parts = (endpoint.namespace.split('/') +
            endpoint.options[:path])
          parts.reject! { |part| part.empty? || part == '/' }
          parts.join('.')
        end

        # Adds OpenTelemetry attributes to the current span.
        #
        # @param [Hash] env The environment hash.
        def telemetry_attributes(env)
          current_span = OpenTelemetry::Trace.current_span
          current_span.add_attributes(
            'http.request_id' => env.fetch(RequestId::KEY, '-'),
            'http.correlation_id' => env.fetch(CorrelationId::KEY, '-')
          )
        end

        # Builds an array of tags to include with our stats.
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @param [Integer] status The HTTP status code.
        # @return [Array<String>]
        def tags(endpoint, status: nil)
          tags = DEFAULT_TAGS + %W[
            method:#{endpoint.options[:method].first}
            endpoint:#{endpoint_name(endpoint)}
          ]
          tags << "status:#{status}" unless status.nil?

          tags
        end
      end
    end
  end
end

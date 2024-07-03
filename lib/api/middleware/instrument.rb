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

        # Builds the base name for our stats.
        #
        # @param [Grape::Endpoint] endpoint The Grape endpoint.
        # @return [String]
        def stat_name(endpoint)
          "endpoint.#{endpoint.options[:path].join('.')}"
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

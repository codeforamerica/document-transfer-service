# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'opentelemetry-exporter-otlp'
require 'opentelemetry/instrumentation/delayed_job'
require 'opentelemetry/instrumentation/faraday'
require 'opentelemetry/instrumentation/grape'
require 'opentelemetry/instrumentation/rack'

require_relative 'base'
require_relative '../../document_transfer'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap OpenTelemetry.
      class Telemetry < Base
        # Configure the OpenTelemetry SDK.
        def bootstrap
          OpenTelemetry::SDK.configure do |c|
            c.service_name = DocumentTransfer::NAME
            c.service_version = DocumentTransfer::VERSION
            c.use_all
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'opentelemetry-exporter-otlp'
require 'opentelemetry/instrumentation/faraday'
require 'opentelemetry/instrumentation/grape'
require 'opentelemetry/instrumentation/rack'
require 'semantic_logger'

require_relative 'lib/document_transfer'
require_relative 'lib/api/api'
require_relative 'lib/api/middleware/instrument'
require_relative 'lib/api/middleware/request_id'
require_relative 'lib/api/middleware/request_logging'

# Configure the logger.
SemanticLogger.default_level = ENV.fetch('LOG_LEVEL',
                                         DocumentTransfer::DEFAULT_LOG_LEVEL)
SemanticLogger.application = DocumentTransfer::NAME
SemanticLogger.add_appender(io: $stdout, formatter: :json)

# Configure telemetry reporting.
OpenTelemetry::SDK.configure do |c|
  c.service_name = DocumentTransfer::NAME
  c.service_version = DocumentTransfer::VERSION
  c.use_all
end

# Include Rack middleware.
use Rack::RewindableInput::Middleware
use DocumentTransfer::API::Middleware::RequestId
use DocumentTransfer::API::Middleware::RequestLogging
use DocumentTransfer::API::Middleware::Instrument
use(*OpenTelemetry::Instrumentation::Rack::Instrumentation.instance.middleware_args)

run DocumentTransfer::API::API

# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'opentelemetry-exporter-otlp'
require 'opentelemetry/instrumentation/faraday'
require 'opentelemetry/instrumentation/grape'
require 'opentelemetry/instrumentation/rack'
require 'semantic_logger'
require 'sequel'

require_relative 'lib/document_transfer'
require_relative 'lib/api/api'
require_relative 'lib/api/middleware'
require_relative 'lib/config/application'
require_relative 'lib/model'

# Connect to the database.
config = DocumentTransfer::Config::Application.from_environment
Sequel.connect(config.database_credentials)

# Load all models.
DocumentTransfer::Model.load

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
use(*OpenTelemetry::Instrumentation::Rack::Instrumentation.instance.middleware_args)
DocumentTransfer::API::Middleware.load.each { |m| use m }

run DocumentTransfer::API::API

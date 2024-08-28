# frozen_string_literal: true

require 'rackup'
require 'opentelemetry/instrumentation/rack'

require_relative 'lib/bootstrap/api'
require_relative 'lib/config/application'
require_relative 'lib/api/api'
require_relative 'lib/api/middleware'

# Bootstrap the application.
config = DocumentTransfer::Config::Application.from_environment
DocumentTransfer::Bootstrap::API.new(config).bootstrap

# Load Rack middleware.
use Rack::RewindableInput::Middleware
use(*OpenTelemetry::Instrumentation::Rack::Instrumentation.instance.middleware_args)
DocumentTransfer::API::Middleware.load.each { |m| use m }

run DocumentTransfer::API::API

# frozen_string_literal: true

require 'factory_bot'
require 'rack'
require 'rack/test'

# Configure code coverage reporting.
if ENV.fetch('COVERAGE', false)
  require 'simplecov'

  SimpleCov.minimum_coverage 95
  SimpleCov.start do
    add_filter '/spec/'

    track_files 'lib/**/*.rb'
  end
end

# We need to build a Rack app for testing. This ensures that we're including the
# appropriate middleware and that the app is configured correctly.
ENV['RACK_ENV'] = 'test'
RSPEC_APP = Rack::Builder.parse_file('config.ru')

# Mock out the logger, and make the mock available to all tests.
RSPEC_LOGGER = SemanticLogger::Test::CaptureLogEvents.new

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before do
    RSPEC_LOGGER.clear
    allow(SemanticLogger::Logger).to receive(:new).and_return(RSPEC_LOGGER)
  end
end

# Include shared examples and factories.
require_relative 'support/examples'
require_relative 'support/factories'

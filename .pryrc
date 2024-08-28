# frozen_string_literal: true

require_relative 'lib/config/application'
require_relative 'lib/bootstrap/console'

config = DocumentTransfer::Config::Application.from_environment
DocumentTransfer::Bootstrap::Console.new(config).bootstrap

# frozen_string_literal: true

require 'sequel'

require_relative 'lib/config/application'
require_relative 'lib/model'

config = DocumentTransfer::Config::Application.from_environment
Sequel.connect(config.database_url)

DocumentTransfer::Model.load

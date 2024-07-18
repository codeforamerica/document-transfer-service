# frozen_string_literal: true

require 'sequel'

require_relative 'lib/config/application'
require_relative 'lib/model'

config = DocumentTransfer::Config::Application.from_environment
Sequel.connect(config.database_url)

DocumentTransfer::Model.load

color = "\e[1;32m"
color = "\e[1;31m" if config.prod?
color = "\e[1;33m" if config.prod_like?

Pry.config.prompt_name = "document_transfer(#{config.environment})"
Pry.config.prompt = Pry::Prompt.new(
  :document_transfer,
  'Document transfer console prompt',
  [
    proc { |_, _, p| "#{color}[#{p.input_ring.count}] #{p.config.prompt_name} > \e[0m" },
    proc { |_, _, p| "#{color}[#{p.input_ring.count}] #{p.config.prompt_name} * \e[0m" }
  ]
)

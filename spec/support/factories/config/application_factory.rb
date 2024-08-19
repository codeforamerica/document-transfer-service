# frozen_string_literal: true

require_relative '../../../../lib/config/application'

FactoryBot.define do
  factory :config_application, class: DocumentTransfer::Config::Application do
    transient do
      environment { 'test' }
    end

    initialize_with { new(attributes.merge(environment:)) }
  end
end

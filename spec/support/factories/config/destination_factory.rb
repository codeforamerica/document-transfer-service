# frozen_string_literal: true

require_relative '../../../../lib/config/destination'

FactoryBot.define do
  factory :config_destination, class: DocumentTransfer::Config::Destination do
    transient do
      type { :onedrive }
      path { 'rspec/path' }
    end

    initialize_with { new(attributes.merge(type:, path:)) }
  end
end

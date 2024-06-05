# frozen_string_literal: true

FactoryBot.define do
  factory :config_source, class: 'DocumentTransfer::Config::Source' do
    transient do
      type { :url }
      url { 'https://example.com/file.pdf' }
    end

    initialize_with { new(attributes.merge(type:, url:)) }
  end
end

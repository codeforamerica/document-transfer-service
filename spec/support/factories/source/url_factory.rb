# frozen_string_literal: true

require_relative '../../../../lib/source/url'

FactoryBot.define do
  factory :source_url, class: DocumentTransfer::Source::Url do
    transient do
      config { build(:config_source, type: :url, url: 'https://example.com/file.pdf') }
    end

    initialize_with { new(config) }
  end
end

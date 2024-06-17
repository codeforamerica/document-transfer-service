# frozen_string_literal: true

require_relative '../../../../lib/destination/one_drive'

FactoryBot.define do
  factory :destination_one_drive, class: DocumentTransfer::Destination::OneDrive do
    transient do
      config { build(:config_destination, type: :onedrive, path: 'rspec-docs') }
    end

    initialize_with { new(config) }
  end
end

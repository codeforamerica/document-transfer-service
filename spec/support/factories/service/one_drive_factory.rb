# frozen_string_literal: true

require_relative '../../../../lib/service/one_drive'

FactoryBot.define do
  factory :service_one_drive, class: DocumentTransfer::Service::OneDrive

  after(:build) do |factory|
    allow(factory).to receive(:upload)
  end
end

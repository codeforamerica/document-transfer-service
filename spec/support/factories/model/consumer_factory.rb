# frozen_string_literal: true

require 'faker'

require_relative '../../../../lib/model/consumer'

FactoryBot.define do
  factory :consumer, class: DocumentTransfer::Model::Consumer do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    active { true }
    created { Time.now }
    updated { Time.now }

    to_create do |instance|
      instance.save_changes
      instance
    end
  end
end

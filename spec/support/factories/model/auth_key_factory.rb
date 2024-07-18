# frozen_string_literal: true

require_relative '../../../../lib/model/auth_key'

FactoryBot.define do
  factory :auth_key, class: DocumentTransfer::Model::AuthKey do
    transient do
      plain_key { SecureRandom.hex(32) }
    end

    association :consumer

    active { true }
    key { BCrypt::Password.create(plain_key) }
    created { Time.now }
    updated { Time.now }
    expires { Time.now + DocumentTransfer::Model::AuthKey::DEFAULT_EXPIRATION }

    initialize_with { new(attributes) }
    to_create do |instance|
      instance.save_changes
      instance
    end
  end
end

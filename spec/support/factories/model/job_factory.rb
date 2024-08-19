# frozen_string_literal: true

require 'faker'

require_relative '../../../../lib/delayed/backend/sequel'

FactoryBot.define do
  factory :job, class: Delayed::Backend::Sequel::Job do
    id { Faker::Number.number(digits: 3) }
  end
end

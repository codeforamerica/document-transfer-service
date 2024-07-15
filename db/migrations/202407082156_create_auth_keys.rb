# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:auth_keys) do
      UUID :id, primary_key: true
      foreign_key :consumer_id, :consumers, type: :uuid, null: false
      TrueClass :active, default: true
      String :key, null: false
      DateTime :created, null: false
      DateTime :updated, null: false
      DateTime :expires, null: false
      DateTime :last_access
    end
  end
end

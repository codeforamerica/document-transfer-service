# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:consumers) do
      UUID :id, primary_key: true
      String :name, null: false
      TrueClass :active, default: true
      DateTime :created, null: false
      DateTime :updated, null: false
    end
  end
end

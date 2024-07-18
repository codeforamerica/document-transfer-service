# frozen_string_literal: true

module DocumentTransfer
  # Module for all models.
  module Model
    # Load all models into memory so that they don't need to be required
    # individually.
    def self.load
      require_relative 'model/auth_key'
      require_relative 'model/consumer'
    end
  end
end

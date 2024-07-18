# frozen_string_literal: true

require 'sequel'

module DocumentTransfer
  module Model
    # Represents a consumer of the service.
    class Consumer < Sequel::Model
      plugin :boolean_readers
      plugin :timestamps, create: :created, update: :updated, update_on_create: true
      plugin :uuid, field: :id

      one_to_many :auth_keys

      # Retrieve any active, unexpired keys for the consumer.
      #
      # @return [Sequel::Dataset]
      def active_keys
        auth_keys_dataset.where(active: true, expires: Time.now..)
      end

      # Destroy any associated auth keys before destroying the consumer.
      def before_destroy
        auth_keys.each(&:destroy)
      end
    end
  end
end

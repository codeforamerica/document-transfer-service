# frozen_string_literal: true

require 'bcrypt'
require 'sequel'

module DocumentTransfer
  module Model
    # Represents an authentication key for a consumer of the service.
    class AuthKey < Sequel::Model
      include BCrypt

      DEFAULT_EXPIRATION = 90 * 24 * 60 * 60

      plugin :boolean_readers
      plugin :timestamps, create: :created, update: :updated, update_on_create: true
      plugin :uuid, field: :id

      many_to_one :consumer

      attr_reader :plain_key

      def before_create
        # Store the key as plain text in a transient property so that the caller
        # can retrieve it. This is the only time the key is available in plain
        # text.
        @plain_key = SecureRandom.base64(32)
        self.key = Password.create(@plain_key)
        self.expires = Time.now + DEFAULT_EXPIRATION unless expires
      end

      # Allow comparing this model to a plain text key to determine if it's
      # valid.
      def ==(other)
        return super unless other.is_a?(String)

        Password.new(key) == other
      end
    end
  end
end

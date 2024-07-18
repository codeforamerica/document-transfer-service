# frozen_string_literal: true

require_relative '../base'

module DocumentTransfer
  module Rake
    module Database
      # Base class for database rake tasks.
      class Base < Rake::Base
        attr_reader :name

        private

        # Retrieve the database name from the connection URL.
        #
        # @return [String]
        def db_name
          url = URI.parse(config.database_url)
          url.path[1..] || ''
        end

        # Connect to the database for the duration of the provided block.
        #
        # @yieldparam [Sequel::Database]
        def db_connection(&)
          Sequel.connect(config.database_url, &)
        end

        # Connect to the base database for the duration of the provided block.
        #
        # This is useful when the application database has not be created yet.
        #
        # @yieldparam [Sequel::Database]
        def base_db_connection(&)
          url = URI.parse(config.database_url)
          url.path = "/#{config.base_database}"
          Sequel.connect(url.to_s, &)
        end
      end
    end
  end
end

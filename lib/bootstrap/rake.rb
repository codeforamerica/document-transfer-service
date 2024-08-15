# frozen_string_literal: true

require_relative 'stage/database'
require_relative 'stage/jobs'
require_relative 'stage/logger'

module DocumentTransfer
  module Bootstrap
    # Boostrap the API.
    class Rake
      include SemanticLogger::Loggable

      def initialize(config)
        @config = config
      end

      def bootstrap
        Stage::Logger.new(@config).bootstrap

        # We may not have a database available when running rake tasks. Try to
        # bootstrap it, but don't fail if it's not available.
        begin
          Stage::Database.new(@config).bootstrap
          Stage::Jobs.new(@config).bootstrap
        rescue Sequel::DatabaseConnectionError => e
          warn("Database connection error: #{e.message}")
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'mode'
require_relative 'stage/database'
require_relative 'stage/jobs'
require_relative 'stage/logger'
require_relative 'stage/rake_tasks'

module DocumentTransfer
  module Bootstrap
    # Boostrap the API.
    class Rake < Mode
      include SemanticLogger::Loggable

      def bootstrap
        Stage::Logger.new(config).bootstrap

        # We may not have a database available when running rake tasks. Try to
        # bootstrap it, but don't fail if it's not available.
        begin
          Stage::Database.new(config).bootstrap
          Stage::Jobs.new(config).bootstrap
        rescue Sequel::DatabaseConnectionError => e
          warn("Database connection error: #{e.message}")
        end

        Stage::RakeTasks.new(config).bootstrap
      end
    end
  end
end

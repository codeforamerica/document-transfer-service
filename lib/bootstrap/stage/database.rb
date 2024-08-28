# frozen_string_literal: true

require 'sequel'

require_relative 'base'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap the database connection.
      class Database < Base
        MIGRATIONS_PATH = '../../../db/migrations'

        # Make sure we have a database connection and run migrations.
        def bootstrap
          migrate(connect_with_create)
        end

        private

        # Create a database connection.
        #
        # @return [Sequel::Database]
        def connect
          Sequel.connect(config.database_credentials)
        end

        # Create a database connection and create the database if it does not
        # exist.
        #
        # @return [Sequel::Database]
        def connect_with_create
          connect
        rescue Sequel::DatabaseConnectionError => e
          raise unless e.message =~ /database ".+" does not exist/

          create
          connect
        end

        # Create the database.
        def create
          Sequel.connect(config.database_credentials(base: true)) do |db|
            db.execute "CREATE DATABASE #{db.literal(Sequel.lit(config.database_name))}"
            logger.info('Created database', database: config.database_name)
          end
        end

        # Run any pending migrations.
        #
        # This will use an advisory lock on supported databases to prevent
        # multiple instances from running migrations at the same time.
        #
        # @param db [Sequel::Database] The database connection.
        # @param version [Integer] The version to migrate to.
        # @return [void]
        def migrate(db, version: nil)
          Sequel.extension :migration
          Sequel::Migrator.run(db, 'db/migrations', target: version,
                                                    use_advisory_lock: lock?)
        end

        # Whether to use an advisory lock when running migrations.
        #
        # @return [Boolean]
        def lock?
          config.database_adapter == 'postgresql'
        end
      end
    end
  end
end

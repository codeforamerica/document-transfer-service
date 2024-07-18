# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Rake
    module Database
      # Rake task to drop the database.
      #
      # If the database doesn't exist, this task will succeed.
      class Drop < Base
        def initialize(name = :drop, *args, &)
          super
        end

        private

        def define(args, &task_block)
          desc 'Drop the current database'
          task(name, *args) do |_, task_args|
            raise EnvironmentError, 'Cannot drop the production database' if config.prod?

            execute(task_args, &task_block)
            puts 'Database dropped successfully.'
          end
        end

        def execute(task_args, &task_block)
          before_drop(task_args, &task_block) if task_block
          drop_database
        rescue Sequel::DatabaseError => e
          raise unless e.wrapped_exception.is_a?(PG::InvalidCatalogName)
        end

        def before_drop(args, &block)
          # Connect to the database and yield to the block before we delete
          # it.
          db_connection do |db|
            yield(*[self, db, args].slice(0, block.arity))
          end
        end

        def drop_database
          base_db_connection do |db|
            db.execute "DROP DATABASE #{db.literal(Sequel.lit(db_name))}"
          end
        end
      end
    end
  end
end

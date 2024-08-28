# frozen_string_literal: true

require 'sequel'
require 'pg'

require_relative 'base'

module DocumentTransfer
  module Rake
    module Database
      # Rake task to create the database.
      #
      # If the database already exists, this task will succeed without calling
      # the provided block.
      class Create < Base
        def initialize(name = :create, *args, &)
          super
        end

        private

        def define(args, &task_block)
          desc 'Create the database'
          task(name, *args) do |_, task_args|
            begin
              create_database
              after_create(task_args, &task_block) if task_block
            rescue Sequel::DatabaseError => e
              raise unless e.wrapped_exception.is_a?(PG::DuplicateDatabase)
            end

            puts 'Database created successfully.'
          end
        end

        def after_create(args, &block)
          # Connect to the newly created database and yield to the block.
          db_connection do |db|
            yield(*[self, db, args].slice(0, block.arity))
          end
        end

        def create_database
          # Connect to the base database to create the new database.
          base_db_connection do |db|
            db.execute "CREATE DATABASE #{db.literal(Sequel.lit(db_name))}"
          end
        end
      end
    end
  end
end

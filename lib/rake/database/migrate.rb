# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Rake
    module Database
      # Rake task to run database migrations.
      class Migrate < Base
        def initialize(name = :create, *args, &)
          super
        end

        private

        def define(args, &task_block)
          desc 'Run migrations'
          task(name, *args) do |_, task_args|
            Sequel.extension :migration
            version = task_args.to_a.first if task_args
            db_connection do |db|
              yield(*[self, :pre, task_args].slice(0, task_block.arity)) if task_block
              Sequel::Migrator.run(db, 'db/migrations', target: version)
              yield(*[self, :post, task_args].slice(0, task_block.arity)) if task_block
            end
          end
        end
      end
    end
  end
end

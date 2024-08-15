# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Rake
    module Database
      # Rake task to set up the current database.
      class Setup < Base
        def initialize(name = :setup, *args, &)
          super
        end

        private

        def define(args, &task_block)
          desc 'Setup the database'
          task(name, *args) do |_, _task_args|
            ::Rake::Task['db:create'].invoke(task_block)
            ::Rake::Task['db:migrate'].invoke(task_block)
          end
        end
      end
    end
  end
end

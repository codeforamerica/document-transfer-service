# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Rake
    module Database
      # Rake task to reset the current database.
      class Reset < Base
        def initialize(name = :reset, *args, &)
          super
        end

        private

        def define(args, &task_block)
          desc 'Reset the database'
          task(name, *args) do |_, _task_args|
            ::Rake::Task['db:drop'].invoke(task_block)
            ::Rake::Task['db:setup'].invoke(task_block)
          end
        end
      end
    end
  end
end

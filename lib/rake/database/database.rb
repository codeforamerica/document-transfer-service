# frozen_string_literal: true

require 'sequel/core'

require_relative '../base'
require_relative 'create'
require_relative 'drop'
require_relative 'migrate'
require_relative 'reset'
require_relative 'setup'

module DocumentTransfer
  module Rake
    module Database
      # Rake namespace for managing the database.
      class Database < Rake::Base
        class EnvironmentError < RuntimeError; end

        def initialize(name = :db, *args, &)
          super
        end

        private

        def define(args, &)
          namespace(@name) do
            Create.new(:create, *args, &)
            Drop.new(:drop, *args, &)
            Migrate.new(:migrate, *args, &)
            Reset.new(:reset, *args, &)
            Setup.new(:setup, *args, &)
          end
        end
      end
    end
  end
end

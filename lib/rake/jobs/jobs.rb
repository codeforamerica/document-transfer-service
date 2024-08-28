# frozen_string_literal: true

require 'sequel/core'

require_relative '../base'
require_relative 'queue'
require_relative 'schedule'

module DocumentTransfer
  module Rake
    module Jobs
      # Rake namespace for managing background jobs.
      class Jobs < Rake::Base
        def initialize(name = :jobs, *args, &)
          super
        end

        private

        def define(args, &)
          namespace(@name) do
            Queue.new(:queue, *args, &)
            Schedule.new(:schedule, *args, &)
          end
        end
      end
    end
  end
end

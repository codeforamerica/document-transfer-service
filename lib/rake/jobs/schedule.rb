# frozen_string_literal: true

require_relative '../base'

module DocumentTransfer
  module Rake
    module Jobs
      # Schedule all recurring jobs.
      class Schedule < Rake::Base
        attr_reader :name

        def initialize(name = :schedule, *args, &)
          super
        end

        private

        def define(args, &)
          desc 'Schedule recurring jobs'
          task(name, *args) do |_, _task_args|
            count = DocumentTransfer::Job.schedule

            puts "#{count} jobs scheduled successfully."
          end
        end
      end
    end
  end
end

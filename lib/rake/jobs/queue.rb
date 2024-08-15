# frozen_string_literal: true

require_relative '../base'
require_relative '../../job/queue'

module DocumentTransfer
  module Rake
    module Jobs
      # Get information about the job queue.
      class Queue < Rake::Base
        attr_reader :name

        def initialize(name = :queue, *args, &)
          super
        end

        private

        def define(args, &)
          desc 'Get information about the job queue'
          task(name, *args) do |_, _task_args|
            queue = DocumentTransfer::Job::Queue.new

            puts queue.stats.to_json
          end
        end
      end
    end
  end
end

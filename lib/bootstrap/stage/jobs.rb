# frozen_string_literal: true

require 'delayed_job'

require_relative 'base'
require_relative '../../job'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap background jobs.
      class Jobs < Base
        # Setup the job queue and schedule recurring jobs.
        def bootstrap
          require_relative '../../delayed/backend/sequel'
          Delayed::Worker.backend = Delayed::Backend::Sequel::Job
          Delayed::Worker.logger = SemanticLogger['Delayed::Worker']
          Job.schedule
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'delayed_job'

require_relative 'base'
require_relative '../../document_transfer'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap rake tasks.
      class RakeTasks < Base
        # Load all custom rake tasks.
        def bootstrap
          DocumentTransfer.load_rake_tasks
        end
      end
    end
  end
end

# frozen_string_literal: true

module DocumentTransfer
  # Top-level module for the application bootstrap system.
  module Bootstrap
    # Load all boostrap stages into memory.
    #
    # This is a convenience method to ensure all stages are loaded. It does not
    # execute any of the stages.
    def self.load_stages
      require_relative 'bootstrap/stage/database'
      require_relative 'bootstrap/stage/jobs'
      require_relative 'bootstrap/stage/logger'
      require_relative 'bootstrap/stage/models'
      require_relative 'bootstrap/stage/prompt'
      require_relative 'bootstrap/stage/telemetry'
      require_relative 'bootstrap/stage/worker'
    end
  end
end

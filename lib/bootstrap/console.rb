# frozen_string_literal: true

require_relative 'mode'
require_relative 'stage/database'
require_relative 'stage/logger'
require_relative 'stage/jobs'
require_relative 'stage/models'
require_relative 'stage/prompt'
require_relative 'stage/telemetry'

module DocumentTransfer
  module Bootstrap
    # Boostrap the console.
    class Console < Mode
      def bootstrap # rubocop:disable Metrics/AbcSize
        Stage::Prompt.new(config).bootstrap
        Stage::Logger.new(config).bootstrap
        Stage::Database.new(config).bootstrap
        Stage::Models.new(config).bootstrap
        Stage::Jobs.new(config).bootstrap
        Stage::Telemetry.new(config).bootstrap
      end
    end
  end
end

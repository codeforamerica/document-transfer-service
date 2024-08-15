# frozen_string_literal: true

require_relative 'stage/database'
require_relative 'stage/logger'
require_relative 'stage/models'
require_relative 'stage/telemetry'
require_relative 'stage/jobs'

module DocumentTransfer
  module Bootstrap
    # Boostrap the API.
    class API
      def initialize(config)
        @config = config
      end

      def bootstrap
        Stage::Logger.new(@config).bootstrap
        Stage::Database.new(@config).bootstrap
        Stage::Models.new(@config).bootstrap
        Stage::Jobs.new(@config).bootstrap
        Stage::Telemetry.new(@config).bootstrap
      end
    end
  end
end

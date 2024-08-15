# frozen_string_literal: true

require 'semantic_logger'

require_relative 'base'
require_relative '../../document_transfer'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap the logger.
      class Logger < Base
        # Configure the logger for the application.
        def bootstrap
          SemanticLogger.default_level = @config.log_level
          SemanticLogger.application = DocumentTransfer::NAME
          SemanticLogger.add_appender(io: $stdout, formatter: :json)
        end
      end
    end
  end
end

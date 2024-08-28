# frozen_string_literal: true

require 'semantic_logger'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Base class for bootstrap stages.
      class Base
        include SemanticLogger::Loggable

        attr_reader :config

        # Initialize the bootstrap stage.
        #
        # @param config [Config] The configuration.
        # @return [self]
        def initialize(config)
          @config = config
        end

        # Bootstrap the stage.
        #
        # @return [void]
        #
        # @raise [NotImplementedError] If the method is not implemented.
        def bootstrap
          raise NotImplementedError
        end
      end
    end
  end
end

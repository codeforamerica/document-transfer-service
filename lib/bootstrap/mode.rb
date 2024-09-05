# frozen_string_literal: true

require_relative 'stage/database'
require_relative 'stage/jobs'
require_relative 'stage/logger'
require_relative 'stage/rake_tasks'

module DocumentTransfer
  module Bootstrap
    # Base class for bootstrapping the application.
    #
    # @abstract Subclass and implement {#bootstrap} to define a boostrap mode.
    class Mode
      attr_reader :config

      # Initialize the mode.
      #
      # @param config [DocumentTransfer::Config::Application] The application
      #   configuration.
      def initialize(config)
        @config = config
      end

      # Execute the bootstrap process.
      #
      # @raise [NotImplementedError] If the method is not implemented.
      def bootstrap
        raise NotImplementedError
      end
    end
  end
end

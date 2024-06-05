# frozen_string_literal: true

module DocumentTransfer
  module Destination
    # Base class for destinations.
    class Base
      # Initializes the destination.
      #
      # @param config [DocumentTransfer::Config::Source] The configuration for the destination.
      def initialize(config)
        @config = config
      end

      # Transfers a document to the destination.
      #
      # @param source [DocumentTransfer::Source::Base] The source document.
      def transfer(source)
        raise NotImplementedError
      end
    end
  end
end

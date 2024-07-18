# frozen_string_literal: true

module DocumentTransfer
  module Destination
    # Base class for destinations.
    #
    # @abstract Subclass and override {#transfer} to implement a destination.
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
      # @return [Hash] The result of the transfer.
      #
      # @raise [NotImplementedError] If the method is not implemented by the subclass.
      # @raise [DestinationError] If the transfer fails.
      def transfer(source)
        raise NotImplementedError
      end
    end
  end
end

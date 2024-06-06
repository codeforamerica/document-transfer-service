# frozen_string_literal: true

module DocumentTransfer
  module Source
    # Base class for sources.
    #
    # @abstract Subclass and override {#filename} and {#mime_type} to implement a source.
    class Base
      # Initializes the source.
      #
      # @param config [DocumentTransfer::Config::Source] Configuration for the source.
      def initialize(config)
        @config = config
      end

      # Returns the name of the document.
      #
      # @return [String]
      #
      # @raise [NotImplementedError] If the method is not implemented by the subclass.
      def filename
        raise NotImplementedError
      end

      # Returns the mime type of the document.
      #
      # @return [String]
      #
      # @raise [NotImplementedError] If the method is not implemented by the subclass.
      def mime_type
        raise NotImplementedError
      end
    end
  end
end

# frozen_string_literal: true

module DocumentTransfer
  module Source
    # Base class for sources.
    #
    # @abstract Subclass and override {#fetch}, {#filename}, {#mime_type}, and
    #   {#size} to implement a source.
    class Base
      # Initializes the source.
      #
      # @param config [DocumentTransfer::Config::Source] Configuration for the
      #   source.
      def initialize(config)
        @config = config
      end

      # Fetches the document from the source.
      #
      # @return [String] The document content.
      #
      # @raise [NotImplementedError] If the method is not implemented by the
      #   subclass.
      # @raise [SourceError] If the document cannot be retrieved.
      def fetch
        raise NotImplementedError
      end

      # Returns the name of the document.
      #
      # @return [String]
      #
      # @raise [NotImplementedError] If the method is not implemented by the
      #   subclass.
      # @raise [SourceError] If the size cannot be retrieved.
      def filename
        raise NotImplementedError
      end

      # Returns the mime type of the document.
      #
      # @return [String]
      #
      # @raise [NotImplementedError] If the method is not implemented by the
      #   subclass.
      # @raise [SourceError] If the mime-type cannot be retrieved.
      def mime_type
        raise NotImplementedError
      end

      # Returns the size of the document, in bytes.
      #
      # @return [Integer]
      #
      # @raise [NotImplementedError] If the method is not implemented by the
      #   subclass.
      # @raise [SourceError] If the size cannot be retrieved.
      def size
        raise NotImplementedError
      end
    end
  end
end

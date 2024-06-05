# frozen_string_literal: true

module DocumentTransfer
  module Source
    # Base class for sources.
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
      def filename
        raise NotImplementedError
      end

      # Returns the mime type of the document.
      #
      # @return [String]
      def mime_type
        raise NotImplementedError
      end
    end
  end
end

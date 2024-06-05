# frozen_string_literal: true

require_relative 'source/url'

module DocumentTransfer
  # Source base module.
  module Source
    class InvalidSourceError < ArgumentError; end

    # Load the appropriate source based on the configuration.
    #
    # @param config [DocumentTransfer::Config::Source] The configuration for the source.
    # @return [DocumentTransfer::Source::Base] The source object.
    #
    # @todo Make this method more dynamic rather than using a simple switch.
    def self.load(config)
      case config.type
      when :url
        Url.new(config)
      else
        raise InvalidSourceError, "Unknown source type: #{config.type}"
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'destination/one_drive'

module DocumentTransfer
  # Destination base module.
  module Destination
    class InvalidDestinationError < ArgumentError; end
    class DestinationError < RuntimeError; end

    # Load the appropriate destination based on the configuration.
    #
    # @param config [DocumentTransfer::Config::Destination] The configuration for the destination.
    # @return [DocumentTransfer::Destination::Base] The destination object.
    #
    # @todo Make this method more dynamic rather than using a simple switch.
    def self.load(config)
      case config.type
      when :onedrive
        OneDrive.new(config)
      else
        raise InvalidDestinationError, "Unknown destination type: #{config.type}"
      end
    end
  end
end

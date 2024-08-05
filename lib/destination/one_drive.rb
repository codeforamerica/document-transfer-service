# frozen_string_literal: true

require_relative 'base'
require_relative '../service/one_drive'

module DocumentTransfer
  module Destination
    # Microsoft OneDrive destination.
    class OneDrive < Base
      def transfer(source)
        result = service.upload(source, path: @config.path, filename: @config.filename)

        { path: File.join(@config.path, @config.filename) }
      rescue Microsoft::Graph::Error => e
        raise DestinationError, "Failed to upload to OneDrive: #{e.message}"
      end

      private

      def service
        @service ||= Service::OneDrive.new
      end
    end
  end
end

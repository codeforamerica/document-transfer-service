# frozen_string_literal: true

require_relative 'base'
require_relative '../service/one_drive'

module DocumentTransfer
  module Destination
    # Microsoft OneDrive destination.
    class OneDrive < Base
      def transfer(source)
        service.upload(source, path: @config.path, filename: @config.filename)
      end

      private

      def service
        @service ||= Service::OneDrive.new
      end
    end
  end
end

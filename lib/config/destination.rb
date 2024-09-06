# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Config
    # Configuration for a document destination.
    class Destination < Base
      option :type, type: Symbol, enum: [:onedrive], required: true
      option :path, type: String, default: ''
      option :filename, type: String, default: ''
    end
  end
end

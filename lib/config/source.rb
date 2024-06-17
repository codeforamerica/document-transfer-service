# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Config
    # Configuration for a document source.
    class Source < Base
      option :type, type: Symbol, enum: [:url], required: true
      # TODO: Make url required only when type requires it.
      option :url, type: String, required: true
    end
  end
end

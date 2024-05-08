# frozen_string_literal: true

require 'grape'

require_relative 'health'

module DocumentService
  # Base API class for the document transfer service.
  class API < Grape::API
    format :json

    mount DocumentService::Health
  end
end

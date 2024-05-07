# frozen_string_literal: true

require 'grape'

module DocumentService
  # Health check endpoint for the API.
  class Health < Grape::API
    get :health do
      { status: 'ok' }
    end
  end
end

# frozen_string_literal: true

require 'grape'
require 'statsd-instrument'

module DocumentService
  # Health check endpoint for the API.
  class Health < Grape::API
    get :health do
      StatsD.increment('health_check')
      { status: 'ok' }
    end
  end
end

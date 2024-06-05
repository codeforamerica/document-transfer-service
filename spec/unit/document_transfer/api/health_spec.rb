# frozen_string_literal: true

require 'rack/test'

require_relative '../../../../lib/api/api'
require_relative '../../../../lib/api/health'

describe DocumentTransfer::API::Health do
  include Rack::Test::Methods
  include StatsD::Instrument::Matchers

  def app
    DocumentTransfer::API::API
  end

  describe 'GET /health' do
    it 'returns 200' do
      get '/health'
      expect(last_response).to be_ok
    end

    it 'includes a status message' do
      get '/health'
      expect(last_response.body).to eq({ status: 'ok' }.to_json)
    end

    it 'increments the health check counter' do
      expect { get '/health' }.to trigger_statsd_increment('health_check')
    end
  end
end

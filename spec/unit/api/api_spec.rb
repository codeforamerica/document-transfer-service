# frozen_string_literal: true

require 'rack/test'

require_relative '../../../lib/api/api'

describe DocumentService::API do
  include Rack::Test::Methods
  include StatsD::Instrument::Matchers

  def app
    DocumentService::API
  end

  describe 'GET /health' do
    it 'returns 200' do
      get '/health'
      expect(last_response.status).to eq(200)
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

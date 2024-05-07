# frozen_string_literal: true

require 'rack/test'

require_relative '../../../lib/api/api'

describe DocumentService::API do
  include Rack::Test::Methods

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
  end
end

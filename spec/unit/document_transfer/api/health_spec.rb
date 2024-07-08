# frozen_string_literal: true

require_relative '../../../../lib/api/api'
require_relative '../../../../lib/api/health'

describe DocumentTransfer::API::Health do
  include Rack::Test::Methods

  def app
    RSPEC_APP
  end

  describe 'GET /health' do
    include_examples 'instrumented', :get, '/health', :health
    include_examples 'request_ids', :get, '/health'

    it 'returns 200' do
      get '/health'
      expect(last_response).to be_ok
    end

    it 'includes a status message' do
      get '/health'
      expect(last_response.body).to eq({ status: 'ok' }.to_json)
    end
  end
end

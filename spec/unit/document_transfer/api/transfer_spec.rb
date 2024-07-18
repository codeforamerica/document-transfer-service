# frozen_string_literal: true

require_relative '../../../../lib/api/api'
require_relative '../../../../lib/api/transfer'

describe DocumentTransfer::API::Transfer do
  include Rack::Test::Methods

  let(:auth_key) { create(:auth_key) }
  let(:rack_env) do
    {
      'HTTP_AUTHORIZATION' => "Bearer realm=\"#{auth_key.consumer.id}\" #{auth_key.plain_key}"
    }
  end

  def app
    RSPEC_APP
  end

  describe 'POST /transfer' do
    let(:source) { build(:source_url) }
    let(:destination) { build(:destination_one_drive) }
    let(:params) do
      {
        source: {
          type: 'url',
          url: 'https://example.com/rspec.pdf'
        },
        destination: {
          type: 'onedrive',
          path: 'rspec-folder'
        }
      }
    end

    before do
      allow(DocumentTransfer::Source::Url).to receive(:new).and_return(source)
      allow(DocumentTransfer::Destination::OneDrive).to receive(:new).and_return(destination)
      allow(destination).to receive(:transfer).and_return({ path: 'rspec-folder/rspec.pdf' })
    end

    include_examples 'instrumented', :post, '/transfer', :transfer
    include_examples 'request_ids', :get, '/transfer'

    it 'succeeds' do
      post '/transfer', params, rack_env

      expect(last_response).to be_created
    end

    it 'transfers the document' do
      post '/transfer', params, rack_env

      expect(destination).to have_received(:transfer).with(source)
    end

    it 'returns a success message' do
      post '/transfer', params, rack_env

      expect(last_response.body).to eq({
        status: 'ok',
        destination: 'onedrive',
        path: 'rspec-folder/rspec.pdf'
      }.to_json)
    end
  end
end

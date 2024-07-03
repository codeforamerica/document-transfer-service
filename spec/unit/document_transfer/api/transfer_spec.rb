# frozen_string_literal: true

require_relative '../../../../lib/api/api'
require_relative '../../../../lib/api/transfer'

describe DocumentTransfer::API::Transfer do
  include Rack::Test::Methods

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

    it 'succeeds' do
      post '/transfer', params

      expect(last_response).to be_created
    end

    it 'transfers the document' do
      post '/transfer', params

      expect(destination).to have_received(:transfer).with(source)
    end

    it 'returns a success message' do
      post '/transfer', params

      expect(last_response.body).to eq({
        status: 'ok',
        destination: 'onedrive',
        path: 'rspec-folder/rspec.pdf'
      }.to_json)
    end
  end
end

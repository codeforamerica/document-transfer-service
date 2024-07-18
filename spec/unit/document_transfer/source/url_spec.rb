# frozen_string_literal: true

require_relative '../../../../lib/source/url'
require_relative '../../../../lib/config/source'

describe DocumentTransfer::Source::Url do
  subject(:source) { described_class.new(config) }

  let(:config) { build(:config_source) }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |c| c.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
    stubs.get(config.url) do
      [
        200,
        { 'Content-Type' => 'application/pdf', 'Content-Length' => '1024' },
        'This would be binary data'
      ]
    end
  end

  # Clear default connection to prevent it from being cached between different
  # tests. This allows for each test to have its own set of stubs.
  after do
    Faraday.default_connection = nil
  end

  describe '#filename' do
    it 'returns the filename from the url' do
      expect(source.filename).to eq('file.pdf')
    end
  end

  describe '#mime_type' do
    it 'returns the mime type of the file' do
      expect(source.mime_type).to eq('application/pdf')
    end
  end

  describe '#fetch' do
    it 'returns the file contents' do
      expect(source.fetch).to eq('This would be binary data')
    end
  end

  describe '#size' do
    it 'returns the size of the file' do
      expect(source.size).to eq('1024')
    end
  end
end

# frozen_string_literal: true

require_relative '../../../../lib/destination/one_drive'

RSpec.describe DocumentTransfer::Destination::OneDrive do
  subject(:dest) { described_class.new(config) }

  let(:config) { build(:config_destination) }
  let(:service) { build(:service_one_drive) }
  let(:source) { build(:source_url) }

  before do
    allow(DocumentTransfer::Service::OneDrive).to receive(:new).and_return(service)
    allow(service).to receive(:upload)
      .and_return(Microsoft::Graph::JSONStruct.new(name: 'rspec.pdf'))
  end

  describe '#transfer' do
    it 'uploads the document' do
      dest.transfer(source)

      expect(service).to have_received(:upload).with(
        source, path: config.path, filename: config.filename
      )
    end
  end
end

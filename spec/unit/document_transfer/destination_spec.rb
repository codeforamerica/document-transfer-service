# frozen_string_literal: true

require_relative '../../../lib/destination'

RSpec.describe DocumentTransfer::Destination do
  describe '.load' do
    let(:config) { build(:config_destination, type: destination_type) }
    let(:destination) { build(:destination_one_drive) }
    let(:destination_type) { :onedrive }

    before do
      allow(destination.class).to receive(:new).and_return(destination)
    end

    it 'returns the proper destination' do
      expect(described_class.load(config)).to eq(destination)
    end

    context 'when an invalid destination type is provided' do
      before do
        # If we try to set an invalid type directly on the config object, it
        # will raise an error.
        allow(config).to receive(:type).and_return(:invalid)
      end

      it 'raises an exception' do
        expect { described_class.load(config) }.to \
          raise_error(DocumentTransfer::Destination::InvalidDestinationError)
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../../../lib/source'

RSpec.describe DocumentTransfer::Source do
  describe '.load' do
    let(:config) { build(:config_source, type: source_type) }
    let(:source) { build(:source_url) }
    let(:source_type) { :url }

    before do
      allow(source.class).to receive(:new).and_return(source)
    end

    it 'returns the proper source' do
      expect(described_class.load(config)).to eq(source)
    end

    context 'when an invalid source type is provided' do
      before do
        # If we try to set an invalid type directly on the config object, it
        # will raise an error.
        allow(config).to receive(:type).and_return(:invalid)
      end

      it 'raises an exception' do
        expect { described_class.load(config) }.to \
          raise_error(DocumentTransfer::Source::InvalidSourceError)
      end
    end
  end
end

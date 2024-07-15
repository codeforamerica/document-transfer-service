# frozen_string_literal: true

require_relative File.join(ROOT, 'lib/model')

describe DocumentTransfer::Model do
  describe '.load' do
    let(:models) do
      %w[AuthKey Consumer]
    end

    it 'loads models in the expected order' do
      described_class.load

      models.each do |model|
        expect(Object.const_defined?("DocumentTransfer::Model::#{model}")).to \
          be(true)
      end
    end
  end
end

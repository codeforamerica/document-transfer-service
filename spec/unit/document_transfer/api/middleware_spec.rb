# frozen_string_literal: true

require_relative File.join(ROOT, 'lib/api/middleware')

describe DocumentTransfer::API::Middleware do
  describe '.load' do
    let(:middleware) do
      [
        DocumentTransfer::API::Middleware::RequestId,
        DocumentTransfer::API::Middleware::CorrelationId,
        DocumentTransfer::API::Middleware::Instrument,
        DocumentTransfer::API::Middleware::RequestLogging,
        DocumentTransfer::API::Middleware::AuthKey
      ]
    end

    it 'loads middleware in the expected order' do
      expect(described_class.load).to eq(middleware)
    end
  end
end

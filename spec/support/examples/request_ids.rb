# frozen_string_literal: true

# Verify expected expected ids are added to trace the request.
RSpec.shared_examples 'request_ids' do |method, path|
  include StatsD::Instrument::Matchers

  subject(:response) { send(method, path, defined?(params) ? params : {}) }

  let(:id_format) { /\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/ }

  it 'includes a request id' do
    expect(response.headers['x-request-id']).to match(id_format)
  end

  it 'includes a correlation id' do
    expect(response.headers['x-correlation-id']).to match(id_format)
  end
end

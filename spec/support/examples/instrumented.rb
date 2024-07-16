# frozen_string_literal: true

require 'statsd-instrument'

# Verify endpoint instrumentation.
RSpec.shared_examples 'instrumented' do |method, path, endpoint_name|
  include StatsD::Instrument::Matchers

  subject(:rack_response) do
    send(method, path,
         defined?(params) ? params : {},
         defined?(rack_env) ? rack_env : {})
  end

  let(:tags) { %W[endpoint:#{endpoint_name} method:#{method.upcase}] }

  it 'increments the endpoint counter' do
    expect { rack_response }.to \
      trigger_statsd_increment('endpoint.requests.count', tags: include(*tags))
  end

  it 'measures the endpoint duration' do
    expect { rack_response }.to \
      trigger_statsd_measure('endpoint.requests.duration', tags: include(*tags))
  end
end

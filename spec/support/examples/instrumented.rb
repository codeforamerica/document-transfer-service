# frozen_string_literal: true

require 'statsd-instrument'

# Verify endpoint instrumentation.
RSpec.shared_examples 'instrumented' do |method, path, endpoint_name|
  include StatsD::Instrument::Matchers

  subject(:response) { send(method, path, defined?(params) ? params : {}) }

  let(:tags) { %W[endpoint:#{endpoint_name} method:#{method.upcase}] }

  it 'increments the endpoint counter' do
    expect { response }.to trigger_statsd_increment('endpoint.requests.count',
                                                    tags: include(*tags))
  end

  it 'measures the endpoint duration' do
    expect { response }.to trigger_statsd_measure('endpoint.requests.duration',
                                                  tags: include(*tags))
  end
end

# frozen_string_literal: true

require 'statsd-instrument'

# Verify endpoint instrumentation.
RSpec.shared_examples 'instrumented' do |method, path, stat|
  include StatsD::Instrument::Matchers

  it 'increments the endpoint counter' do
    expect { send(method, path, defined?(params) ? params : {}) }.to \
      trigger_statsd_increment("endpoint.#{stat}.requests")
  end

  it 'measures the endpoint duration' do
    expect { send(method, path) }.to \
      trigger_statsd_measure("endpoint.#{stat}.duration")
  end
end

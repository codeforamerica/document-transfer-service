# frozen_string_literal: true

require_relative '../../../../lib/bootstrap/worker'

RSpec.describe DocumentTransfer::Bootstrap::Worker do
  include_examples 'bootstrap_stages', %i[logger database jobs telemetry worker]
end

# frozen_string_literal: true

require_relative '../../../../lib/bootstrap/api'

RSpec.describe DocumentTransfer::Bootstrap::API do
  include_examples 'bootstrap_stages', %i[logger database models jobs telemetry]
end

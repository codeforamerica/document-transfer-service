# frozen_string_literal: true

require_relative '../../../../lib/bootstrap/console'

RSpec.describe DocumentTransfer::Bootstrap::Console do
  include_examples 'bootstrap_stages', %i[prompt logger database models jobs telemetry]
end

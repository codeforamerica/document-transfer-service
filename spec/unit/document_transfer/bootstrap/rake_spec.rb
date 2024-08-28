# frozen_string_literal: true

require_relative '../../../../lib/bootstrap/rake'

RSpec.describe DocumentTransfer::Bootstrap::Rake do
  include_examples 'bootstrap_stages', %i[logger database jobs rake_tasks]
end

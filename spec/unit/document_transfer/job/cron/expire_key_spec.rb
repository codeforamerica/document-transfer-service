# frozen_string_literal: true

require 'fugit'
require 'fugit/cron'

require_relative '../../../../../lib/job/cron/expire_key'

RSpec.describe DocumentTransfer::Job::Cron::ExpireKey do
  subject(:job) { described_class.new }

  let!(:auth_keys) do
    {
      valid: create(:auth_key),
      expired: create(:auth_key, expires: Time.now - 1),
      inactive: create(:auth_key, expires: Time.now - 1, active: false)
    }
  end

  describe '.cron_expression' do
    it 'contains a valid cron expression' do
      expect { Fugit::Cron.do_parse(described_class.cron_expression) }.not_to \
        raise_error
    end
  end

  describe '#perform' do
    it 'deactivates expired active keys' do
      job.perform
      expect(auth_keys[:expired].reload.active?).to be(false)
    end

    it 'does not deactivate valid keys' do
      job.perform
      expect(auth_keys[:valid].reload.active?).to be(true)
    end

    # We're not using a spy here, so we can't use `have_received`.
    # rubocop:disable RSpec/MessageSpies
    it 'does not deactivate inactive keys' do
      expect(auth_keys[:expired]).not_to receive(:update)
      job.perform
    end
    # rubocop:enable RSpec/MessageSpies
  end
end

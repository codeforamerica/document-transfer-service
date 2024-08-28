# frozen_string_literal: true

require 'statsd-instrument'

require_relative '../../../../../lib/bootstrap/stage/worker'
require_relative '../../../../../lib/job/queue'

# We're using a mock database connection here, rather than a spy, so we can't
# use `.have_received`.
RSpec.describe DocumentTransfer::Bootstrap::Stage::Worker do
  include StatsD::Instrument::Matchers

  subject(:stage) { described_class.new(config) }

  let(:config) { build(:config_application) }
  let(:stats)  { { recurring: 2, running: 2, oldest: 3600, total: 6, waiting: 3 } }

  describe '#bootstrap' do
    # rubocop:disable RSpec/SubjectStub
    before do
      allow(Thread).to receive(:new).and_yield
      stage.queue = instance_double(DocumentTransfer::Job::Queue, stats:)
      allow(stage).to receive(:sleep)
      allow(stage).to receive(:loop).and_yield
    end
    # rubocop:enable RSpec/SubjectStub

    it 'reports the age of the oldest job' do
      expect { stage.bootstrap }.to \
        trigger_statsd_measure('jobs.queue.oldest.age', value: stats[:oldest])
    end

    it 'reports the number of recurring jobs' do
      expect { stage.bootstrap }.to \
        trigger_statsd_measure('jobs.queue.size.recurring', value: stats[:recurring])
    end

    it 'reports the number of running jobs' do
      expect { stage.bootstrap }.to trigger_statsd_measure('jobs.queue.size.running')
    end

    it 'reports the number of total jobs' do
      expect { stage.bootstrap }.to \
        trigger_statsd_measure('jobs.queue.size.total', value: stats[:total])
    end

    it 'reports the number of waiting jobs' do
      expect { stage.bootstrap }.to \
        trigger_statsd_measure('jobs.queue.size.waiting', value: stats[:waiting])
    end
  end
end

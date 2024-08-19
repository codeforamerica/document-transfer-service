# frozen_string_literal: true

require_relative '../../../../lib/job/queue'

RSpec.describe DocumentTransfer::Job::Queue do
  subject(:queue) { described_class.new }

  before do
    create(:job, cron: '* * * * *', run_at: Time.now - 86_400, locked_at: Time.now - 30)
    create(:job, run_at: Time.now - 3600)
    create(:job, run_at: Time.now - 60)
    create(:job, cron: '0 10 * * *')
    create(:job, run_at: Time.now + 300)
    create(:job, run_at: Time.now - 43_200, locked_at: Time.now - 30)
  end

  describe '#stats' do
    it 'returns statistics about the job queue' do
      expect(queue.stats).to include(
        recurring: 2,
        running: 2,
        total: 6,
        waiting: 3
      )
    end

    # Comparing time values is tricky when working with sub-second precision.
    # Convert the age to an integer to perform seconds-based comparisons.
    it 'includes the age of the oldest non-recurring job in waiting' do
      expect(queue.stats[:oldest].to_i).to eq(3600)
    end
  end

  describe '#recurring' do
    it 'returns the number of jobs with cron schedules' do
      expect(queue.recurring).to eq(2)
    end
  end

  describe '#oldest' do
    it 'returns the age of the oldest non-recurring job in waiting' do
      expect(queue.oldest.to_i).to eq(3600)
    end
  end

  describe '#running' do
    it 'returns the number of jobs currently being worked' do
      expect(queue.running).to eq(2)
    end
  end

  describe '#total' do
    it 'returns the total number of jobs in the queue' do
      expect(queue.total).to eq(6)
    end
  end

  describe '#waiting' do
    it 'returns the number of jobs waiting to be worked' do
      expect(queue.waiting).to eq(3)
    end
  end
end

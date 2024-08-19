# frozen_string_literal: true

require_relative '../../../lib/job'

RSpec.describe DocumentTransfer::Job do
  let(:recurring_jobs) do
    ['ExpireKey']
  end

  describe '.schedule' do
    it 'schedules all recurring jobs' do
      described_class.schedule
      recurring_jobs.each do |job|
        klass = DocumentTransfer::Job::Cron.const_get(job)
        expect(klass.scheduled?).to be(true)
      end
    end
  end

  describe '.unschedule' do
    it 'unschedules all recurring jobs' do
      described_class.unschedule
      recurring_jobs.each do |job|
        klass = DocumentTransfer::Job::Cron.const_get(job)
        expect(klass.scheduled?).to be(false)
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../../../../../lib/job/cron/base'

RSpec.describe DocumentTransfer::Job::Cron::Base do
  subject(:job) do
    Class.new(described_class) do
      self.cron_expression = '* * * * *'

      def perform
        true
      end
    end
  end

  let(:expected_time) do
    now = DateTime.now
    Time.new(now.year, now.month, now.day, now.hour, now.min + 1)
  end

  before do
    stub_const('DocumentTransfer::Job::Cron::Test', job)
    DocumentTransfer::Job.unschedule
  end

  describe '.schedule' do
    it 'schedules the job' do
      pp(job.scheduled?)
      expect(job.schedule.run_at).to be_a(Time)
    end

    it 'sets the job to run at the next scheduled time' do
      pp(job.scheduled?)
      expect(job.schedule.run_at).to eq(expected_time)
    end

    it 'does not reschedule the job' do
      job.schedule
      expect(job.schedule).to be_nil
    end
  end

  describe '.remove' do
    it 'unschedules the job' do
      record = job.schedule
      expect(job.remove).to eq(record)
    end

    it 'does not error if the job is not scheduled' do
      expect(job.remove).to be_nil
    end
  end

  describe '.reschedule' do
    it 'reschedules the job' do
      record = job.schedule
      expect(job.reschedule.id).not_to eq(record.id)
    end
  end

  describe '.scheduled?' do
    it 'returns true if the job is scheduled' do
      job.schedule
      expect(job.scheduled?).to be(true)
    end

    it 'returns false if the job is not scheduled' do
      expect(job.scheduled?).to be(false)
    end
  end

  describe 'delayed_job' do
    it 'returns the delayed job' do
      record = job.schedule
      expect(job.delayed_job).to eq(record)
    end

    it 'returns no job if nothing is scheduled' do
      expect(job.delayed_job).to be_nil
    end
  end

  describe '#after' do
    it 'sets the schedule_instead_of_destroy flag' do
      record = job.new
      record.after
      expect(record.schedule_instead_of_destroy).to be(true)
    end
  end

  describe '#queue' do
    it 'schedules the job' do
      expect(job.new.queue.run_at).to eq(expected_time)
    end
  end
end

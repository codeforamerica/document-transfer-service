# frozen_string_literal: true

require_relative '../../../../../../lib/delayed/backend/sequel'

RSpec.describe Delayed::Backend::Sequel::Job do
  subject!(:job) { create(:job, params) }

  let(:params) { {} }

  describe '.clear_locks!' do
    let(:params) { super().merge(locked_by: 'rspec', locked_at: Time.now) }

    it 'clears all locks' do
      expect { described_class.clear_locks!('rspec') }.to \
        change { job.refresh.locked_by }.to(nil).and \
          change { job.refresh.locked_at }.to(nil)
    end
  end

  describe '.reserve' do
    it 'reserves the first job available' do
      expect { described_class.reserve('rspec', 300) }.to \
        change { job.refresh.locked_by }.to('rspec').and(change { job.refresh.locked_at })
    end
  end

  describe '#destroy' do
    let(:params) do
      super().merge(cron: '* * * * *')
    end

    before do
      job.payload_object = double
    end

    context 'when the job should be rescheduled' do
      before do
        job.run_at = Time.now - 86_400
        job.payload_object = Struct.new(:reschedule_instead_of_destroy).new(true)
      end

      it 'does not destroy the job' do
        expect { job.destroy }.not_to change(described_class, :count)
      end

      it 'reschedules the job' do
        expect { job.destroy }.to change(job, :run_at)
      end
    end

    it 'destroys the job' do
      expect { job.destroy }.to change(described_class, :count).by(-1)
    end
  end

  describe '#schedule_next_run' do
    let(:params) do
      super().merge(
        cron: '* * * * *',
        locked_by: 'rspec',
        locked_at: Time.now
      )
    end

    it 'increases the number of attempts' do
      expect { job.schedule_next_run }.to change(job, :attempts).by(1)
    end

    it 'sets the run_at time' do
      job.run_at = Time.now - 86_400
      expect { job.schedule_next_run }.to change(job, :run_at)
    end

    it 'unlocks the job' do
      expect { job.schedule_next_run }.to \
        change(job, :locked_by).to(nil).and change(job, :locked_at).to(nil)
    end
  end

  describe '#lock_exclusively!' do
    context 'when the job is not locked' do
      it 'locks the job' do
        expect { job.lock_exclusively!(300, 'rspec') }.to \
          change(job, :locked_by).to('rspec').and change(job, :locked_at)
      end
    end

    context 'when the job is locked by another worker' do
      let(:params) { super().merge(locked_by: 'other', locked_at: Time.now) }

      it 'does not lock the job' do
        expect { job.lock_exclusively!(300, 'rspec') }.not_to change(job, :locked_by)
      end
    end

    context 'when the job is locked by the current worker' do
      let(:params) { super().merge(locked_by: 'rspec', locked_at: Time.now - 300) }

      it 'regains the lock' do
        expect { job.lock_exclusively!(300, 'rspec') }.to change(job, :locked_at)
      end
    end
  end
end

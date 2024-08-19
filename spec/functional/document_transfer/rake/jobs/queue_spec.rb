# frozen_string_literal: true

require 'rake'

describe 'jobs:queue', type: :functional do
  include_context 'with rake'

  before do
    create(:job, cron: '* * * * *', run_at: Time.now - 86_400, locked_at: Time.now - 30)
    create(:job, run_at: Time.now - 3600)
    create(:job, run_at: Time.now - 60)
    create(:job, cron: '0 10 * * *')
    create(:job, run_at: Time.now + 300)
    create(:job, run_at: Time.now - 43_200, locked_at: Time.now - 30)
  end

  it 'returns valid json' do
    expect(JSON.parse(invoke_task)).to be_a(Hash)
  end

  it 'returns statistics about the job queue' do
    expect(JSON.parse(invoke_task, symbolize_names: true)).to eq({
                                                                   recurring: 2,
                                                                   oldest: 3600,
                                                                   running: 2,
                                                                   total: 6,
                                                                   waiting: 3
                                                                 })
  end
end

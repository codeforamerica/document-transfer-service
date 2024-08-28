# frozen_string_literal: true

require 'rake'

describe 'jobs:schedule', type: :functional do
  include_context 'with rake'

  let(:expected_count) { 1 }

  it 'schedules all recurring jobs' do
    invoke_task
    expect(Delayed::Job.count).to eq(expected_count)
  end
end

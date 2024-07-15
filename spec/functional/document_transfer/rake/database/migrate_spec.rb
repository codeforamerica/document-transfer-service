# frozen_string_literal: true

require 'rake'

describe 'db:migrate', type: :functional do
  include_context 'with rake'

  before do
    allow(Sequel::Migrator).to receive(:run)
  end

  it 'migrates the database' do
    task.invoke
    expect(Sequel::Migrator).to have_received(:run)
  end

  it 'migrates to a specific version' do
    task.invoke(123)
    expect(Sequel::Migrator).to have_received(:run)
      .with(anything, 'db/migrations', target: 123)
  end
end

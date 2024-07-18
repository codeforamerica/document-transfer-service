# frozen_string_literal: true

require 'rake'
require 'pg'

describe 'db:reset', type: :functional do
  include_context 'with rake'

  before do
    allow(Rake::Task).to receive(:[]).and_return(
      instance_double(Rake::Task, invoke: nil)
    )
  end

  it 'drops the database' do
    task.invoke
    expect(Rake::Task).to have_received(:[]).with('db:drop')
  end

  it 'runs setup' do
    task.invoke
    expect(Rake::Task).to have_received(:[]).with('db:setup')
  end
end

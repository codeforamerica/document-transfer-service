# frozen_string_literal: true

require 'rake'
require 'pg'

describe 'db:setup', type: :functional do
  include_context 'with rake'

  before do
    allow(Rake::Task).to receive(:[]).and_return(
      instance_double(Rake::Task, invoke: nil)
    )
  end

  it 'creates the database' do
    task.invoke
    expect(Rake::Task).to have_received(:[]).with('db:create')
  end

  it 'runs migrations' do
    task.invoke
    expect(Rake::Task).to have_received(:[]).with('db:migrate')
  end
end

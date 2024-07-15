# frozen_string_literal: true

require 'rake'
require 'pg'

describe 'db:drop', type: :functional do
  include_context 'with rake'

  before do
    allow_any_instance_of(Sequel::SQLite::Database).to receive(:execute)
  end

  it 'drops the database' do
    expect_any_instance_of(Sequel::SQLite::Database).to receive(:execute)
      .with(/DROP DATABASE /)
    task.invoke
  end

  context 'when the database does not exist' do
    before do
      exception = Sequel::DatabaseError.new
      exception.wrapped_exception = PG::InvalidCatalogName.new
      allow_any_instance_of(Sequel::SQLite::Database).to receive(:execute)
        .and_raise(exception)
    end

    it 'does not raise an error' do
      expect { task.invoke }.not_to raise_error
    end
  end
end

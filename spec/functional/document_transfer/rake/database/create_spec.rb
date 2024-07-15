# frozen_string_literal: true

require 'rake'
require 'pg'

describe 'db:create', type: :functional do
  include_context 'with rake'

  before do
    allow_any_instance_of(Sequel::SQLite::Database).to receive(:execute)
  end

  it 'creates the database' do
    expect_any_instance_of(Sequel::SQLite::Database).to receive(:execute)
      .with(/CREATE DATABASE /)
    task.invoke
  end

  context 'when the database already exists' do
    before do
      exception = Sequel::DatabaseError.new
      exception.wrapped_exception = PG::DuplicateDatabase.new
      allow_any_instance_of(Sequel::SQLite::Database).to receive(:execute)
        .and_raise(exception)
    end

    it 'does not raise an error' do
      expect { task.invoke }.not_to raise_error
    end
  end
end

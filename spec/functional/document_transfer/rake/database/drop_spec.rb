# frozen_string_literal: true

require 'rake'
require 'pg'

describe 'db:drop', type: :functional do
  include_context 'with rake'

  let(:db) do
    instance_double(Sequel::SQLite::Database, literal: '', execute: nil)
  end

  before do
    allow(Sequel).to receive(:connect).and_yield(db).and_return(db)
  end

  it 'drops the database' do
    task.invoke
    expect(db).to have_received(:execute).with(/DROP DATABASE /)
  end

  context 'when the database does not exist' do
    before do
      exception = Sequel::DatabaseError.new
      exception.wrapped_exception = PG::InvalidCatalogName.new
      allow(db).to receive(:execute).and_raise(exception)
    end

    it 'does not raise an error' do
      expect { task.invoke }.not_to raise_error
    end
  end
end

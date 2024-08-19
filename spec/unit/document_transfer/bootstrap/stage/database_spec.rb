# frozen_string_literal: true

require_relative '../../../../../lib/bootstrap/stage/database'

# We're using a mock database connection here, rather than a spy, so we can't
# use `.have_received`.
# rubocop:disable RSpec/MessageSpies
RSpec.describe DocumentTransfer::Bootstrap::Stage::Database do
  subject(:stage) { described_class.new(config) }

  let(:config) { build(:config_application, base_database: 'rspec', database_name: 'mock') }
  let(:db) { Sequel.connect('mock://postgresql') }

  before do
    allow(Sequel).to receive(:connect).and_return(db)
    allow(db).to receive(:with_advisory_lock)
  end

  describe '#bootstrap' do
    it 'connects to the database' do
      expect(Sequel).to receive(:connect)
      stage.bootstrap
    end

    it 'runs pending migrations' do
      expect(Sequel::Migrator).to receive(:run)
        .with(db, 'db/migrations', target: nil, use_advisory_lock: true)
      stage.bootstrap
    end

    context "when the database doesn't exist" do
      before do
        allow(Sequel).to receive(:connect).with(config.database_credentials(base: true)).and_yield(db)

        raise_exception = true
        allow(Sequel).to receive(:connect).with(config.database_credentials) do
          next db unless raise_exception

          raise_exception = false
          raise Sequel::DatabaseConnectionError, 'database "mock" does not exist'
        end
      end

      it 'creates the database' do
        expect(db).to receive(:execute).with('CREATE DATABASE mock')
        stage.bootstrap
      end
    end
  end
end
# rubocop:enable RSpec/MessageSpies

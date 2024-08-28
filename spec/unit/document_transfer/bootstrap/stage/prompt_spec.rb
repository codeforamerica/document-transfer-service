# frozen_string_literal: true

require 'statsd-instrument'

require_relative '../../../../../lib/bootstrap/stage/prompt'

# We're using a mock database connection here, rather than a spy, so we can't
# use `.have_received`.
RSpec.describe DocumentTransfer::Bootstrap::Stage::Prompt do
  include StatsD::Instrument::Matchers

  subject(:stage) { described_class.new(config) }

  let(:config) { build(:config_application, params) }
  let(:params) { {} }

  describe '#bootstrap' do
    # rubocop:disable RSpec/MessageSpies
    it 'sets the prompt name' do
      expect(Pry.config).to receive(:prompt_name=).with('document-transfer(test)')
      stage.bootstrap
    end
    # rubocop:enable RSpec/MessageSpies
  end

  describe '#color' do
    context 'when the environment is production' do
      let(:params) { super().merge(environment: 'production') }

      it 'returns red' do
        expect(stage.send(:color)).to eq(described_class::COLOR_RED)
      end
    end

    context 'when the environment is staging' do
      let(:params) { super().merge(environment: 'staging') }

      it 'returns red' do
        expect(stage.send(:color)).to eq(described_class::COLOR_YELLOW)
      end
    end

    context 'when the environment is development' do
      let(:params) { super().merge(environment: 'development') }

      it 'returns red' do
        expect(stage.send(:color)).to eq(described_class::COLOR_GREEN)
      end
    end
  end
end

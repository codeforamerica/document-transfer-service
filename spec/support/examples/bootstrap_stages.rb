# frozen_string_literal: true

require_relative '../../../lib/bootstrap'

# Verify the expected boostrap stages are run.
RSpec.shared_examples 'bootstrap_stages' do |stages|
  subject(:bootstrap) { described_class.new(config) }

  let(:config) { build(:config_application) }
  let!(:bootstrap_stages) do
    DocumentTransfer::Bootstrap.load_stages

    stages.to_h do |stage|
      klass = DocumentTransfer::Bootstrap::Stage.const_get(stage.capitalize)
      double = instance_double(klass, bootstrap: nil)
      allow(klass).to receive(:new).and_return(double)
      [stage, double]
    end
  end

  # The order that stages are loaded is important, so make sure we not only call
  # each stage, but that we do so in the expected order.
  it 'runs the expected bootstrap stages in order' do
    subject.bootstrap
    bootstrap_stages.each_value do |double|
      expect(double).to have_received(:bootstrap).ordered
    end
  end
end

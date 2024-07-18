# frozen_string_literal: true

require_relative '../../../../lib/config/dsl'

describe DocumentTransfer::Config::DSL do
  subject(:config) do
    Class.new do
      include DocumentTransfer::Config::DSL

      def initialize(params = {})
        @params = params
      end

      option :name, type: String, required: true
      option :enum, type: Symbol, enum: %i[one two three], required: true
      option :optional, type: String, default: 'default'
    end
  end

  describe '.option' do
    it 'adds an option' do
      expect(config.instance_variable_get(:@options)).to have_key(:name)
    end

    it 'adds all options' do
      expect(config.instance_variable_get(:@options)[:enum]).to eq(
        type: Symbol, enum: %i[one two three], required: true
      )
    end
  end

  describe '.options' do
    it 'returns the options' do
      expect(config.options.keys).to eq(%i[name enum optional])
    end
  end

  describe '#options' do
    subject(:instance) { config.new }

    it 'returns the options' do
      expect(instance.options.keys).to eq(%i[name enum optional])
    end
  end

  describe '#method_missing' do
    subject(:instance) { config.new(name: 'rspec-config', enum: 'two') }

    it 'returns the value' do
      expect(instance.name).to eq('rspec-config')
    end

    it 'returns the default value' do
      expect(instance.optional).to eq('default')
    end

    it 'returns the formatted value' do
      expect(instance.enum).to eq(:two)
    end

    it 'raises an error for unknown options' do
      expect { instance.unknown }.to raise_error(NoMethodError)
    end
  end

  describe '#format_value' do
    subject(:instance) { config.new }

    it 'returns an expected string' do
      expect(instance.format_value(:name, :rspec)).to be_a(String)
    end

    it 'returns the symbol' do
      expect(instance.format_value(:enum, 'three')).to be_a(Symbol)
    end
  end
end

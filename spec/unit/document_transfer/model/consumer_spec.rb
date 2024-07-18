# frozen_string_literal: true

require_relative '../../../../lib/model/consumer'

RSpec.describe DocumentTransfer::Model::Consumer do
  subject(:model) { described_class.new(params).save_changes }

  let(:params) { { name: 'Test Consumer' } }

  describe '#save' do
    it 'has an id' do
      expect(model.id).to be_a_uuid
    end

    it 'has a created date' do
      expect(model.created).to be_a(Time)
    end

    it 'has an updated date' do
      expect(model.updated).to be_a(Time)
    end

    it 'is active' do
      expect(model.active?).to be(true)
    end
  end

  describe '#active_keys' do
    context 'when no keys exist' do
      it 'returns an empty array' do
        expect(model.active_keys.all).to eq([])
      end
    end

    context 'when active keys exist' do
      let!(:keys) { 2.times.map { create(:auth_key, consumer: model) } }

      it 'returns the active keys' do
        expect(model.active_keys.all).to eq(keys)
      end
    end

    context 'when inactive keys exist' do
      let!(:keys) do
        [
          create(:auth_key, consumer: model),
          create(:auth_key, consumer: model, active: false),
          create(:auth_key, consumer: model, expires: Time.now - (60 * 60 * 24))
        ]
      end

      it 'returns only the active keys' do
        expect(model.active_keys.all).to eq([keys.first])
      end
    end
  end

  describe '#before_destroy' do
    let!(:key) { create(:auth_key, consumer: model) }

    it 'deletes all keys' do
      model.destroy

      expect(key.exists?).to be(false)
    end
  end
end

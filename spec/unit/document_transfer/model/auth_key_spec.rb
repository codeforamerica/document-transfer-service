# frozen_string_literal: true

require_relative '../../../../lib/model/auth_key'

RSpec.describe DocumentTransfer::Model::AuthKey do
  subject(:model) { described_class.new(params).save_changes }

  let(:params) { { consumer: create(:consumer) } }

  describe '#create' do
    it 'has an id' do
      expect(model.id).to be_a_uuid
    end

    it 'has a created date' do
      expect(model.created).to be_a(Time)
    end

    it 'has an updated date' do
      expect(model.updated).to be_a(Time)
    end

    it 'has an expiration date in the future' do
      expect(model.expires).to be > Time.now
    end

    it 'is active' do
      expect(model.active?).to be(true)
    end

    it 'has the plain text key' do
      expect(model.plain_key).to be_a(String)
    end
  end

  describe '#==' do
    let(:plain_key) { model.plain_key }

    it 'returns true for a valid plain text key' do
      expect(model == plain_key).to be(true)
    end

    it 'returns false for an incorrect key' do
      expect(model == SecureRandom.hex(32)).to be(false)
    end
  end
end

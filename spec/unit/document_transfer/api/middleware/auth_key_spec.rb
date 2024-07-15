# frozen_string_literal: true

require 'rack'

require_relative '../../../../../lib/api/middleware/auth_key'

describe DocumentTransfer::API::Middleware::AuthKey do
  subject(:middleware) { described_class.new(app) }

  let(:path) { '/' }
  let(:app) { ->(_env) { [200, {}, 'success'] } }
  let(:plain_key) { 'rspec-valid-key' }
  let(:auth_header) { "Bearer realm=\"rspec-consumer\" #{plain_key}" }
  let(:env) do
    Rack::MockRequest.env_for(
      path,
      DocumentTransfer::API::Middleware::AuthKey::AUTH_HEADER_KEY => auth_header
    )
  end

  describe '#call' do
    let(:key) { build(:auth_key, plain_key:) }

    before do
      allow(DocumentTransfer::Model::Consumer).to receive(:[]).and_return(key.consumer)
      allow(key.consumer).to receive(:active_keys).and_return([key])
    end

    context 'when a valid auth key is found' do
      it 'passes authentication' do
        expect(middleware.call(env).first).to eq(200)
      end

      it 'calls the app' do
        expect(app).to receive(:call)
        middleware.call(env)
      end
    end

    context 'when no valid auth key is found' do
      let(:auth_header) { 'Bearer realm="rspec-consumer" rspec-invalid-key' }

      it 'fails authentication' do
        expect(middleware.call(env).first).to eq(401)
      end

      it 'does not call the app' do
        expect(app).not_to receive(:call)
        middleware.call(env)
      end
    end

    context 'when no auth key is found' do
      before do
        allow(DocumentTransfer::Model::Consumer).to receive(:[]).and_return(nil)
      end

      it 'fails authentication' do
        expect(middleware.call(env).first).to eq(401)
      end

      it 'does not call the app' do
        expect(app).not_to receive(:call)
        middleware.call(env)
      end
    end

    context 'when no auth key is provided' do
      let(:auth_header) { '' }

      it 'fails authentication' do
        expect(middleware.call(env).first).to eq(401)
      end

      it 'does not call the app' do
        expect(app).not_to receive(:call)
        middleware.call(env)
      end
    end

    context 'when no realm is provided' do
      let(:auth_header) { "Bearer #{plain_key}" }

      it 'fails authentication' do
        expect(middleware.call(env).first).to eq(401)
      end

      it 'does not call the app' do
        expect(app).not_to receive(:call)
        middleware.call(env)
      end
    end

    context 'when the endpoint does not require authentication' do
      let(:auth_header) { '' }
      let(:path) { '/health' }

      it 'passes authentication' do
        expect(middleware.call(env).first).to eq(200)
      end

      it 'calls the app' do
        expect(app).to receive(:call)
        middleware.call(env)
      end
    end
  end
end

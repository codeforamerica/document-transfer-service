# frozen_string_literal: true

require_relative '../../../../lib/service/one_drive'

RSpec.describe DocumentTransfer::Service::OneDrive do
  subject(:service) { described_class.new }

  let(:client) { instance_double(Microsoft::Graph) }

  before do
    stub_const('ENV', ENV.to_h.merge(
                        'ONEDRIVE_CLIENT_ID' => 'client_id',
                        'ONEDRIVE_CLIENT_SECRET' => 'client_secret',
                        'ONEDRIVE_DRIVE_ID' => 'drive_id',
                        'ONEDRIVE_TENANT_ID' => 'tenant_id'
                      ))

    # Stub the client and its authentication mechanisms.
    auth_context = instance_double(ADAL::AuthenticationContext)
    client_cred = instance_double(ADAL::ClientCredential)
    token = instance_double(ADAL::SuccessResponse, access_token: 'access_token')
    allow(ADAL::AuthenticationContext).to receive(:new).and_return(auth_context)
    allow(ADAL::ClientCredential).to receive(:new).and_return(client_cred)
    allow(auth_context).to receive(:acquire_token_for_client).and_return(token)
    allow(Microsoft::Graph).to receive(:new).and_return(client)
  end

  describe '#get_items' do
    let(:response) { Microsoft::Graph::JSONStruct.new(value: items) }
    let(:items) do
      [
        Microsoft::Graph::JSONStruct.new(
          id: 'rspec1', name: 'rspec.pdf',
          file: Microsoft::Graph::JSONStruct.new(mime_type: 'application/pdf')
        ),
        Microsoft::Graph::JSONStruct.new(
          id: 'rspec2', name: 'rspec-folder',
          folder: Microsoft::Graph::JSONStruct.new(child_count: 1)
        )
      ]
    end

    before do
      allow(client).to receive(:get).and_return(response)
    end

    it 'gets the items for the specified item ID' do
      service.get_items('rspec_items')

      expect(client).to have_received(:get).with('/drives/drive_id/items/rspec_items/children')
    end

    it 'returns the items' do
      expect(service.get_items('rspec_items')).to eq(items)
    end
  end

  describe '#get_items_recursive' do
    let(:children_response) { Microsoft::Graph::JSONStruct.new(value: children) }
    let(:parent_response) { Microsoft::Graph::JSONStruct.new(value: parents) }
    let(:children) do
      [
        Microsoft::Graph::JSONStruct.new(
          id: 'rspec1', name: 'rspec.pdf',
          file: Microsoft::Graph::JSONStruct.new(mime_type: 'application/pdf'),
          parent_reference: Microsoft::Graph::JSONStruct.new(path: '/drives/drive_id/root:/rspec-parent-folder')
        ),
        Microsoft::Graph::JSONStruct.new(
          id: 'rspec2', name: 'rspec-folder',
          folder: Microsoft::Graph::JSONStruct.new(child_count: 1),
          parent_reference: Microsoft::Graph::JSONStruct.new(path: '/drives/drive_id/root:/rspec-parent-folder')
        )
      ]
    end
    let(:parents) do
      [
        Microsoft::Graph::JSONStruct.new(
          id: 'rspec-parent', name: 'rspec-parent-folder',
          folder: Microsoft::Graph::JSONStruct.new(child_count: 2),
          parent_reference: Microsoft::Graph::JSONStruct.new(path: '/drives/drive_id/root:')
        ),
        Microsoft::Graph::JSONStruct.new(
          id: 'rspec-empty', name: 'rspec-empty-folder',
          folder: Microsoft::Graph::JSONStruct.new(child_count: 0),
          parent_reference: Microsoft::Graph::JSONStruct.new(path: '/drives/drive_id/root:')
        )
      ]
    end

    before do
      allow(client).to receive(:get).and_return(Microsoft::Graph::JSONStruct.new(value: []))
      allow(client).to receive(:get).with('/drives/drive_id/items/rspec-parent/children')
                                    .and_return(children_response).once
      allow(client).to receive(:get).with('/drives/drive_id/items/root/children')
                                    .and_return(parent_response).once
    end

    it 'gets the items for each non-empty folder' do
      service.get_items_recursive

      %w[root rspec-parent rspec2].each do |item_id|
        expect(client).to have_received(:get).with("/drives/drive_id/items/#{item_id}/children")
      end
    end

    it 'does not get children for files' do
      service.get_items_recursive

      %w[rspec1].each do |item_id|
        expect(client).not_to have_received(:get).with("/drives/drive_id/items/#{item_id}/children")
      end
    end

    it 'does not get children for empty folders' do
      service.get_items_recursive

      %w[rspec-empty].each do |item_id|
        expect(client).not_to have_received(:get).with("/drives/drive_id/items/#{item_id}/children")
      end
    end

    it 'returns all items' do
      items = service.get_items_recursive

      expect(items).to eq([
                            { id: parents[0].id, name: parents[0].name, type: :folder,
                              mime_type: nil, children: [
                                                { id: children[0].id, name: children[0].name, type: :file,
                                                  mime_type: children[0].file.mime_type, children: [],
                                                  parent: children[0].parent_reference.path },
                                                { id: children[1].id, name: children[1].name, type: :folder,
                                                  mime_type: nil, children: [],
                                                  parent: children[1].parent_reference.path }
                                              ],
                              parent: parents[0].parent_reference.path },
                            { id: parents[1].id, name: parents[1].name, type: :folder,
                              mime_type: nil, children: [], parent: parents[1].parent_reference.path }
                          ])
    end
  end

  describe '#upload' do
    let(:source) { build(:source_url) }
    let(:response) { Microsoft::Graph::JSONStruct.new }

    before do
      allow(source).to receive_messages(
        fetch: 'file_contents',
        filename: 'rspec.pdf',
        mime_type: 'application/pdf'
      )
      allow(client).to receive(:put).and_return(response)
    end

    it 'uploads the source to the specified path' do
      service.upload(source, path: 'rspec-folder')

      expect(client).to have_received(:put).with(
        '/drives/drive_id/items/root:/rspec-folder/rspec.pdf:/content',
        body: 'file_contents',
        headers: { 'Content-Type' => 'application/pdf' }
      )
    end
  end
end

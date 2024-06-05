# frozen_string_literal: true

require 'adal'
require 'microsoft-graph-client'

module DocumentTransfer
  module Service
    # Service interface for Microsoft OneDrive.
    class OneDrive
      AUTH_AUTHORITY = 'login.microsoftonline.com'
      AUTH_RESOURCE = 'https://graph.microsoft.com'

      def get_items(item_id)
        puts "Getting items for #{item_id}"

        items = client.get("/drives/#{drive_id}/items/#{item_id}/children")
        items.value || []
      end

      def get_items_recursive(item_id = 'root')
        results = []
        items = get_items(item_id)
        items.each do |item|
          puts "Found Item: #{item.name} (#{item.id})"
          results << {
            id: item.id,
            name: item.name,
            type: item.file ? :file : :folder,
            mime_type: item.file ? item.file.mime_type : nil,
            children: get_items_recursive(item.id),
            # children: get_items_recursive("#{item_id}:/#{item.name}"),
            parent: item.parent_reference ? item.parent_reference.path : nil
          }
        end

        results
      end

      def upload(source, path: '', filename: nil)
        path += '/' unless path.empty? || path.end_with?('/')
        filename ||= source.filename
        endpoint = "/drives/#{drive_id}/items/root:/#{path}#{filename}:/content"

        client.put(endpoint, body: source.fetch, headers: { 'Content-Type' => source.mime_type })
      end

      private

      def client
        return @client if @client

        auth_ctx = ADAL::AuthenticationContext.new(AUTH_AUTHORITY,
                                                   ENV['ONEDRIVE_TENANT_ID'])
        client_cred = ADAL::ClientCredential.new(ENV['ONEDRIVE_CLIENT_ID'],
                                                 ENV['ONEDRIVE_CLIENT_SECRET'])
        token = auth_ctx.acquire_token_for_client(AUTH_RESOURCE, client_cred)

        @client = Microsoft::Graph.new(token: token.access_token)
      end

      def drive_id
        ENV['ONEDRIVE_DRIVE_ID']
      end

      def client_depr
        return @client if @client

        context = MicrosoftKiotaAuthenticationOAuth::ClientCredentialContext.new(
          ENV['ONEDRIVE_TENANT_ID'], ENV['ONEDRIVE_CLIENT_ID'], ENV['ONEDRIVE_CLIENT_SECRET'])

        auth = MicrosoftGraphCore::Authentication::OAuthAuthenticationProvider.new(
          context, nil, ["https://graph.microsoft.com/.default"]
        )

        adapter = MicrosoftGraph::GraphRequestAdapter.new(auth)
        @client = MicrosoftGraph::GraphServiceClient.new(adapter)
      end
    end
  end
end

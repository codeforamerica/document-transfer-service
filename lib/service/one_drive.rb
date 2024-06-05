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
        get_items(item_id).map do |item|
          {
            id: item.id,
            name: item.name,
            type: item.file ? :file : :folder,
            mime_type: item.file&.mime_type,
            children: get_items_recursive(item.id),
            parent: item.parent_reference&.path
          }
        end
      end

      def upload(source, path: '', filename: nil)
        path += '/' unless path.empty? || path.end_with?('/')
        filename ||= source.filename
        endpoint = "/drives/#{drive_id}/items/root:/#{path}#{filename}:/content"

        client.put(endpoint, body: source.fetch, headers: { 'Content-Type' => source.mime_type })
      end

      private

      # Creates a new client object once.
      #
      # @todo Get credentials as part of a configuration, rather than
      # environment variables.
      def client
        return @client if @client

        auth_ctx = ADAL::AuthenticationContext.new(AUTH_AUTHORITY,
                                                   ENV.fetch('ONEDRIVE_TENANT_ID', nil))
        client_cred = ADAL::ClientCredential.new(ENV.fetch('ONEDRIVE_CLIENT_ID', nil),
                                                 ENV.fetch('ONEDRIVE_CLIENT_SECRET', nil))
        token = auth_ctx.acquire_token_for_client(AUTH_RESOURCE, client_cred)

        @client = Microsoft::Graph.new(token: token.access_token)
      end

      def drive_id
        ENV.fetch('ONEDRIVE_DRIVE_ID', nil)
      end
    end
  end
end

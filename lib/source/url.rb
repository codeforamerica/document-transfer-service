# frozen_string_literal: true

require 'faraday'

require_relative 'base'

module DocumentTransfer
  module Source
    # Source documents from a provided URL.
    class Url < Base
      def filename
        File.basename(@config.url)
      end

      def mime_type
        response.headers['content-type']
      end

      def fetch
        response.body
      end

      def size
        response.headers['content-length']
      end

      private

      def client
        @client ||= Faraday.new do |conn|
          conn.use Faraday::Response::RaiseError
        end
      end

      def response
        @response ||= client.get(@config.url)
      rescue Faraday::Error => e
        raise SourceError, "Failed to fetch URL: #{e.message}"
      end

      def head
        @head ||= client.head(@config.url)
      end
    end
  end
end

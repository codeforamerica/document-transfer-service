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
        head.headers['content-type']
      end

      def fetch
        client.get(@config.url).body
      end

      def size
        head.headers['content-length']
      end

      private

      def client
        @client ||= Faraday.new(@config.url)
      end

      def head
        @head ||= client.head(@config.url)
      end
    end
  end
end

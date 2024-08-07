# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Config
    # Configuration for the document transfer application.
    class Application < Base
      option :base_database, type: String, default: 'postgres'
      option :database_adapter, type: String, default: 'postgresql'
      option :database_host, type: String, default: 'localhost'
      option :database_name, type: String, default: 'document_transfer'
      option :database_password, type: String, default: ''
      option :database_port, type: Integer, default: 5432
      option :database_user, type: String, default: 'postgres'
      option :environment, type: String, default: 'development',
                           env_variable: 'RACK_ENV'

      def database_credentials
        {
          adapter: database_adapter,
          database: database_name,
          host: database_host,
          password: database_password,
          port: database_port,
          user: database_user
        }
      end

      def prod?
        %w[production prod].include?(environment)
      end

      def prod_like?
        %w[demo staging].include?(environment)
      end
    end
  end
end

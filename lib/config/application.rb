# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Config
    # Configuration for the document transfer application.
    class Application < Base
      option :base_database, type: String, default: 'postgres'
      option :database_url, type: String, required: true
      option :environment, type: String, default: 'development',
                           env_variable: 'RACK_ENV'

      def prod?
        %w[production prod].include?(environment)
      end

      def prod_like?
        %w[demo staging].include?(environment)
      end
    end
  end
end

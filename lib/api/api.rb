# frozen_string_literal: true

require 'grape'
require 'grape-swagger'

require_relative 'health'

module DocumentTransfer
  module API
    # Base API class for the document transfer service.
    class API < Grape::API
      format :json

      mount DocumentTransfer::API::Health

      add_swagger_documentation \
        hide_documentation_path: false,
        mount_path: '/api',
        info: {
          license: 'MIT',
          license_url: 'https://github.com/codeforamerica/document-transfer-service/blob/main/LICENSE',
          title: 'Document Transfer Service API'
        }
    end
  end
end

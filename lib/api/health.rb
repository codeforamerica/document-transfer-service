# frozen_string_literal: true

require 'grape'

require_relative '../response/health_status'

module DocumentTransfer
  module API
    # Health check endpoint for the API.
    class Health < Grape::API
      desc 'Check system health', success: DocumentTransfer::Response::HealthStatus,
                                  stat_name: 'health'
      get :health do
        present DocumentTransfer::Response::HealthStatus.new(status: 'ok')
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Response
    # Represents the health status of the application.
    class HealthStatus < Base
      expose :status, documentation: { type: String, desc: 'The current application health status.' }
    end
  end
end

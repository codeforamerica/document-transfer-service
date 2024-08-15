# frozen_string_literal: true

require_relative 'base'
require_relative '../../model/auth_key'

module DocumentTransfer
  module Job
    module Cron
      # Mark authentication keys that have expired as inactive.
      class ExpireKey < Base
        # Run every day at midnight.
        self.cron_expression = '0 0 * * *'

        def perform
          count = DocumentTransfer::Model::AuthKey.where(
            active: true, expires: ..Time.now
          ).update(active: false)

          logger.info("#{count} expired keys have been deactivated.")
        end
      end
    end
  end
end

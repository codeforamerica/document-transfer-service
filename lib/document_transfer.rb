# frozen_string_literal: true

# Base module for the document transfer service. All classes and modules in this
# service should be nested under this module.
module DocumentTransfer
  DEFAULT_LOG_LEVEL = 'info'
  NAME = 'document-transfer-service'
  VERSION = '0.1.0'

  # Load all of our custom rake tasks.
  def self.load_rake_tasks
    require_relative 'rake/database/database'
    require_relative 'rake/jobs/jobs'

    Rake::Database::Database.new
    Rake::Jobs::Jobs.new
  end
end

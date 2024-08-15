# frozen_string_literal: true

require 'grape-swagger/rake/oapi_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

require_relative 'lib/document_transfer'

require_relative 'lib/bootstrap/rake'
require_relative 'lib/config/application'

require_relative 'lib/api/api'

# Bootstrap the application for rake.
config = DocumentTransfer::Config::Application.from_environment
DocumentTransfer::Bootstrap::Rake.new(config).bootstrap

task default: %i[spec rubocop]

task :environment do # rubocop:disable Rake/Desc
  require_relative 'lib/api/api'
end

GrapeSwagger::Rake::OapiTasks.new('::DocumentTransfer::API::API')

RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop'
end

RSpec::Core::RakeTask.new(:spec)

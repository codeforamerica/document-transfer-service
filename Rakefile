# frozen_string_literal: true

require 'grape-swagger/rake/oapi_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i[spec rubocop]

task :environment do # rubocop:disable Rake/Desc
  require_relative 'lib/api/api'
end

GrapeSwagger::Rake::OapiTasks.new('::DocumentTransfer::API::API')

RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop'
end

RSpec::Core::RakeTask.new(:spec)

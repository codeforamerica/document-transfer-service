# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# TODO: Move to gemspec once a new release has been cut.
# See https://github.com/kklimuk/microsoft-graph-client/pull/4
gem 'microsoft-graph-client', git: 'https://github.com/jamesiarmes/microsoft-graph-client.git', branch: 'non-hash-body'

group :development do
  gem 'pry', '~> 0.14'
  gem 'rake', '~> 13.0'
  gem 'rubocop', '~> 1.48'
  gem 'rubocop-factory_bot', '~> 2.23'
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.22'
  gem 'rubocop-sequel', '~> 0.3'
  gem 'rubocop-yard', '~> 0.9.3'
end

group :test do
  gem 'factory_bot', '~> 6.2'
  gem 'faker', '~> 3.4'
  gem 'rack-test', '~> 2.1'
  gem 'rspec', '~> 3.12'
  gem 'rspec-github', '~> 2.4'
  gem 'rspec-uuid', '~> 0.6'
  gem 'simplecov', '~> 0.22'
  gem 'sqlite3', '~> 2.0'
end

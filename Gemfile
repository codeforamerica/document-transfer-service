# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# TODO: Move to gemspec once a new release has been cut.
# See https://github.com/kklimuk/microsoft-graph-client/pull/4
gem 'microsoft-graph-client', git: 'https://github.com/jamesiarmes/microsoft-graph-client.git', branch: 'non-hash-body'

group :development do
  gem 'rake', '~> 13.0'
  gem 'rubocop', '~> 1.48'
  gem 'rubocop-factory_bot', '~> 2.23'
  gem 'rubocop-rake', '~> 0.6'
  gem 'rubocop-rspec', '~> 2.22'
end

group :test do
  gem 'factory_bot', '~> 6.2'
  gem 'rack-test', '~> 2.1'
  gem 'rspec', '~> 3.12'
  gem 'rspec-github', '~> 2.4'
  gem 'simplecov', '~> 0.22'
end

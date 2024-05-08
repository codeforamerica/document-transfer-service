# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'document-transfer-service'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Document Transfer Service'
  s.description = 'A microservice to securely transfer documents.'
  s.authors     = ['Code for America']
  s.email       = 'infra@codeforamerica.org'
  s.files       = Dir['lib/**/*'] + Dir['Gemfile*'] + ['Rakefile']
  s.homepage    = 'https://codeforamerica.org/programs/social-safety-net/'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/codeforamerica/document-transfer-service/issues',
    'homepage_uri' => s.homepage,
    # Require privileged gem operations (such as publishing) to use MFA.
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/codeforamerica/document-transfer-service'
  }

  s.required_ruby_version = '>= 3.3'

  # Add runtime dependencies.
  s.add_runtime_dependency 'grape', '~> 2.0'
  s.add_runtime_dependency 'rack', '~> 3.0'
  s.add_runtime_dependency 'rackup', '~> 2.1'
  s.add_runtime_dependency 'statsd-instrument', '~> 3.7'
end

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
  s.add_dependency 'adal', '~> 1.0'
  s.add_dependency 'bcrypt', '~> 3.1'
  s.add_dependency 'faraday', '~> 2.9'
  s.add_dependency 'grape', '~> 2.0'
  s.add_dependency 'grape-entity', '~> 1.0'
  s.add_dependency 'grape-swagger', '~> 2.1'
  s.add_dependency 'grape-swagger-entity', '~> 0.5'
  s.add_dependency 'httparty', '~> 0.22'
  s.add_dependency 'opentelemetry-exporter-otlp', '~> 0.27'
  s.add_dependency 'opentelemetry-instrumentation-faraday', '~> 0.24'
  s.add_dependency 'opentelemetry-instrumentation-grape', '~> 0.1'
  s.add_dependency 'opentelemetry-instrumentation-rack', '~> 0.24'
  s.add_dependency 'opentelemetry-sdk', '~> 1.4'
  s.add_dependency 'pg', '~> 1.5'
  s.add_dependency 'rack', '~> 3.0'
  s.add_dependency 'rackup', '~> 2.1'
  s.add_dependency 'semantic_logger', '~> 4.15'
  s.add_dependency 'sequel', '~> 5.82'
  s.add_dependency 'statsd-instrument', '~> 3.7'
end

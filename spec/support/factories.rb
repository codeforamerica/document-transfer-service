# frozen_string_literal: true

# Allow rspec mocks to be used by factories.
FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end

require_relative 'factories/config/destination_factory'
require_relative 'factories/config/source_factory'

require_relative 'factories/destination/one_drive_factory'

require_relative 'factories/model/auth_key_factory'
require_relative 'factories/model/consumer_factory'

require_relative 'factories/service/one_drive_factory'

require_relative 'factories/source/url_factory'

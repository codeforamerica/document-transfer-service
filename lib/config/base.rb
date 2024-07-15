# frozen_string_literal: true

require_relative 'dsl'
require_relative 'from_environment'
require_relative 'validation'

module DocumentTransfer
  module Config
    class InvalidConfigurationError < ArgumentError; end

    # Base class for configuration.
    class Base
      include DSL
      include FromEnvironment
      include Validation

      def initialize(params = {})
        @params = params

        validate
      end
    end
  end
end

# frozen_string_literal: true

require 'configsl'

module DocumentTransfer
  module Config
    # Base class for configuration.
    class Base < ConfigSL::Config
      def initialize(params = {})
        super

        validate!
      end
    end
  end
end

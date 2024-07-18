# frozen_string_literal: true

module DocumentTransfer
  module Config
    # Supports configuration through environment variables.
    #
    # This module should be loaded after the DSL module.
    #
    # By default, options will be read from environment variables with the same
    # name, capitalized. For example, an option named `database_url` will be
    # read as 'DATABASE_URL'. To override this behavior, set the `env_variable`
    # when defining the option.
    module FromEnvironment
      def self.included(base)
        base.extend ClassMethods
      end

      # Class methods necessary for loading configuration from the environment.
      module ClassMethods
        # Create a new instance of the class using values from the environment.
        #
        # @return [self] The new config object
        def from_environment
          params = options.transform_values do |opts|
            ENV.fetch(opts[:env_variable], opts[:default])
          end

          new(params)
        end

        # Override the options method to ensure each option has an environment
        # variable defined.
        def options
          super.each do |name, opts|
            opts[:env_variable] = opts[:env_variable] || name.to_s.upcase
          end
        end
      end
    end
  end
end

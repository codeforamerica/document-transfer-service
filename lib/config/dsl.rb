# frozen_string_literal: true

module DocumentTransfer
  module Config
    # DSL for configuration
    module DSL
      def self.included(base)
        base.extend ClassMethods
      end

      def options
        self.class.options
      end

      def method_missing(name, *args, &)
        super unless options.key?(name)

        @params[name] = format_value(name, args.first) if args.any?
        @params[name] || options[name]&.[](:default)
      end

      def respond_to_missing?(name, include_private = false)
        options.key?(name) || super
      end

      def format_value(option, value)
        return value if value.is_a?(options[option][:type])

        case options[option][:type]
        when Symbol then value.to_sym
        when String then value.to_s
        else value
        end
      end

      # Required class methods for the config DSL.
      #
      # @todo Can we do this without using class variables?
      module ClassMethods
        # rubocop:disable Style/ClassVars
        def option(name, opts = {})
          class_variable_set(:@@options, options.merge({ name => opts }))
        end

        def options
          class_variable_defined?(:@@options) ? class_variable_get(:@@options) : {}
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end

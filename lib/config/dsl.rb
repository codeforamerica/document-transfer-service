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

      def method_missing(name, *args, &block)
        super unless options.key?(name)

        @params[name] = format_value(name, args.first) if args.any?
        @params[name] || options[name]&.[](:default)
      end

      def format_value(option, value)
        case options[option][:type]
        when Symbol then value.to_sym
        when String then value.to_s
        else value
        end
      end

      # Required class methods for the config DSL.
      module ClassMethods
        def option(name, opts = {})
          class_variable_set(:@@options, options.merge({ name => opts }))
        end

        def options
          class_variable_defined?(:@@options) ? class_variable_get(:@@options) : {}
        end
      end
    end
  end
end

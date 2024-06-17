# frozen_string_literal: true

module DocumentTransfer
  module Config
    # Validator for configuration.
    module Validation
      def validate
        errors = validate_required + validate_values
        raise InvalidConfigurationError, errors.join("\n") unless errors.empty?
      end

      def validate_required
        errors = options.select do |name, opts|
          opts[:required] && @params[name].nil?
        end

        errors.empty? ? [] : ["Missing required options: #{errors.keys.join(', ')}"]
      end

      def validate_values
        options.each_with_object([]) do |(name, opts), errors|
          next unless opts[:enum]

          errors << "Invalid value for #{name}: #{@params[name]}" unless opts[:enum].include?(send(name))
        end
      end
    end
  end
end

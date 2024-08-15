# frozen_string_literal: true

require 'pry'

require_relative 'base'
require_relative '../../document_transfer'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap the prompt for the console.
      class Prompt < Base
        # Configure the prompt for the console.
        #
        # This will set the prompt name and color based on the environment to
        # make it easier to identify the environment when using the console.
        #
        # @return [void]
        def bootstrap # rubocop:disable Metrics/AbcSize
          Pry.config.prompt_name = "document-transfer(#{@config.environment})"
          Pry.config.prompt = Pry::Prompt.new(
            :document_transfer,
            'Document transfer console prompt',
            [
              proc { |_, _, p| "#{color}[#{p.input_ring.count}] #{p.config.prompt_name} > \e[0m" },
              proc { |_, _, p| "#{color}[#{p.input_ring.count}] #{p.config.prompt_name} * \e[0m" }
            ]
          )
        end

        private

        # Determine the color to use for the prompt.
        #
        # Green for development, yellow for staging, and red for production.
        #
        # @return [String]
        # @link https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124
        def color
          return "\e[1;31m" if config.prod?
          return "\e[1;33m" if config.prod_like?

          "\e[1;32m"
        end
      end
    end
  end
end

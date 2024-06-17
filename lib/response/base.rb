# frozen_string_literal: true

require 'grape-entity'

module DocumentTransfer
  module Response
    # Base class for response entities.
    class Base < Grape::Entity
      def self.entity_name
        name.split('::').last
      end
    end
  end
end

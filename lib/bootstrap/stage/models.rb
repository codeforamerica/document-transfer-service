# frozen_string_literal: true

require_relative 'base'
require_relative '../../model'

module DocumentTransfer
  module Bootstrap
    module Stage
      # Bootstrap models.
      class Models < Base
        # Load all models into memory.
        def bootstrap
          Model.load
        end
      end
    end
  end
end

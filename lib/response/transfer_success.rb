# frozen_string_literal: true

require_relative 'base'

module DocumentTransfer
  module Response
    # Represents a successful transfer document transfer.
    class TransferSuccess < Base
      expose :status, documentation: { type: String, desc: 'The status of the transfer.' }
      expose :destination, documentation: { type: Symbol, desc: 'The destination type.' }
      expose :path, documentation: { type: String,
                                     desc: 'The path withing the destination where the file was sent.' }
    end
  end
end

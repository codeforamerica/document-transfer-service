# frozen_string_literal: true

require_relative '../config/destination'
require_relative '../config/source'
require_relative '../destination'
require_relative '../source'

module DocumentTransfer
  module API
    # Document transfer endpoint and resources for the API.
    class Transfer < Grape::API
      resource :transfer do
        desc 'Initiate a new transfer.'
        params do
          requires :source, type: Hash, desc: 'The source document.' do
            requires :type, type: Symbol, values: [:url], desc: 'The type of the source document.'
            requires :url, type: String, desc: 'The URL of the document to be ' \
                                               'transferred. Required when the ' \
                                               'source type is "url".',
                           documentation: { format: :uri }
          end

          requires :destination, type: Hash, desc: 'The destination for the document.' do
            requires :type, type: Symbol, values: [:onedrive], desc: 'The document destination type.'
            optional :path, type: String, default: '',
                            desc: 'The path to store the document in the destination.'
            optional :filename, type: String, desc: 'The filename to store the document as in the ' \
                                                    'destination, if different from the source.'
          end
        end
        post do
          source_config = DocumentTransfer::Config::Source.new(params[:source])
          dest_config = DocumentTransfer::Config::Destination.new(params[:destination])
          source = DocumentTransfer::Source.load(source_config)
          destination = DocumentTransfer::Destination.load(dest_config)

          result = destination.transfer(source)

          { status: 'ok', destination: dest_config.type }.merge(result)
        end
      end
    end
  end
end

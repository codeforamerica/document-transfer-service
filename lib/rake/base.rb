# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'

require_relative '../config/application'

module DocumentTransfer
  module Rake
    # Base class for custom rake tasks.
    class Base < ::Rake::TaskLib
      attr_reader :name

      def initialize(name, *args, &)
        super()
        @name = name

        define(args, &)
      end

      private

      def config
        @config ||= DocumentTransfer::Config::Application.from_environment
      end

      def define(args, &)
        raise NotImplementedError
      end
    end
  end
end

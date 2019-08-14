# frozen_string_literal: true

require 'active_support'

module ArgonCallNumberSearch
  module Configurable
    extend ActiveSupport::Concern

    # In an initializer you can set the regular expressions
    # to use to match accession numbers with and without spaces.
    # ArgonCallNumberSearch.configure do |config|
    #   config.acc_num_without_space = 'some regex'
    #   config.acc_num_with_space = 'some regex'
    # end

    included do
      mattr_accessor :acc_num_without_space do
        ENV['ACC_NUM_WITHOUT_SPACE'] ||=
          '^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)([A-Z\d]+)'
      end

      mattr_accessor :acc_num_with_space do
        ENV['ACC_NUM_WITH_SPACE'] ||=
          '^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)(\s+)([A-Z\d]+)'
      end
    end

    module ClassMethods
      def configure
        yield self
      end
    end
  end
end

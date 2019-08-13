# frozen_string_literal: true
require 'argon_call_number_search/version'

module ArgonCallNumberSearch
  autoload :Configurable, 'argon_call_number_search/configurable'
  autoload :SearchBuilderBehavior, 'argon_call_number_search/search_builder_behavior'
  include ArgonCallNumberSearch::Configurable
  include ArgonCallNumberSearch::SearchBuilderBehavior
end

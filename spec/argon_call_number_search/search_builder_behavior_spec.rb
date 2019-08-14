# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'lcsort'

module TrlnArgon
  module Fields
    SHELF_NUMBERS = 'shelf_numbers_tp'
    LC_CALL_NOS_NORMED = 'lc_call_nos_normed_a'
    SHELFKEY = 'shelfkey'
  end
end

class SearchBuilderTestClass
  include ArgonCallNumberSearch::SearchBuilderBehavior
  include TrlnArgon::Fields

  attr_accessor :blacklight_params
end

RSpec.describe ArgonCallNumberSearch::SearchBuilderBehavior do
  let(:solr_parameters) { {} }

  before do
    stub_const('SearchBuilder', SearchBuilderTestClass.new)
    SearchBuilder.blacklight_params = blacklight_parameters
  end

  describe 'lc call number search' do
    let(:blacklight_parameters) do
      { 'search_field' => 'call_number',
        :q => 'PS3623.I556497 P433' }
    end

    it 'generates a solr query' do
      expect(SearchBuilder.add_call_number_query_to_solr(solr_parameters)).to(
        eq('lc_call_nos_normed_a:/PS.3623.I556497.P433(\\..*|-.*)*/ OR ' \
           'shelfkey:/lc:PS.3623.I556497.P433(\\..*|-.*)*/ OR ' \
           '_query_:"{!edismax qf=shelf_numbers_tp pf= pf3= pf2=}' \
           '(PS3623.I556497 P433)"')
      )
    end
  end

  describe 'accession number search' do
    let(:blacklight_parameters) do
      { 'search_field' => 'call_number',
        :q => 'cd 12345' }
    end

    it 'generates a solr query' do
      expect(SearchBuilder.add_call_number_query_to_solr(solr_parameters)).to(
        eq('lc_call_nos_normed_a:/cd 12345(\\..*|-.*)*/ OR '\
           'shelfkey:/lc:cd 12345(\\..*|-.*)*/ OR '\
           '_query_:"{!edismax qf=shelf_numbers_tp pf= pf3= pf2=}'\
           '(cd 12345)" OR '\
           '_query_:"{!edismax qf=shelf_numbers_tp pf= pf3= pf2=}(cd12345)"')
      )
    end
  end
end

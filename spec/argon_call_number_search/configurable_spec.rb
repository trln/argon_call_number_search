# frozen_string_literal: true

RSpec.describe ArgonCallNumberSearch::Configurable do
  describe 'default values' do
    it 'has a default value for acc_num_without_space' do
      expect(ArgonCallNumberSearch.acc_num_without_space).to(
        eq('^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)([A-Z\d]+)')
      )
    end

    it 'has a default value for acc_num_with_space' do
      expect(ArgonCallNumberSearch.acc_num_with_space).to(
        eq('^[\s\d[[:punct:]]]*(CD|DVD|LP|AV|VC|LD)(\s+)([A-Z\d]+)')
      )
    end
  end
end

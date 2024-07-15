require 'rails_helper'

RSpec.describe Income, type: :model do
  describe 'callbacks' do
    let(:ie_statement) { create(:ie_statement) }
    let(:income) { create(:income, ie_statement: ie_statement) }

    it 'calls recommit_ie_statement after commit' do
      expect(income).to receive(:recommit_ie_statement)
      income.save!
    end
  end
end

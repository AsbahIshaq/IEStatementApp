require 'rails_helper'

RSpec.describe Expenditure, type: :model do
  describe 'callbacks' do
    let(:ie_statement) { create(:ie_statement) }
    let(:expenditure) { create(:expenditure, ie_statement: ie_statement) }

    it 'calls recommit_ie_statement after commit' do
      expect(expenditure).to receive(:recommit_ie_statement)
      expenditure.save!
    end
  end
end

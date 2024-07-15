require 'rails_helper'

RSpec.describe IeStatement, type: :model do
	let(:user) { create(:user) }

  describe 'validations' do
		let(:ie_statement) { create(:ie_statement, :incomes_and_expenditures) }

    it 'is valid with valid attributes' do
      expect(ie_statement).to be_valid
    end

    it 'is not valid without a month' do
      ie_statement.month = nil
      expect(ie_statement).to_not be_valid
    end

    it 'is not valid with an invalid month' do
      ie_statement.month = 'invalid_month'
      expect(ie_statement).to_not be_valid
    end
  end

  describe 'callbacks and calculations' do
	  let(:ie_statement) { create(:ie_statement) }

    it 'calculates total income before save' do
      ie_statement.incomes.create(name: 'Job', amount: 5000)
      ie_statement.save
      expect(ie_statement.total_income).to eq(5000)
    end

    it 'calculates total expenditure before save' do
      ie_statement.expenditures.build(name: 'Rent', amount: 2000)
      ie_statement.save
      expect(ie_statement.total_expenditure).to eq(2000)
    end

    it 'calculates disposable income before save' do
      ie_statement.incomes.build(name: 'Job', amount: 5000)
      ie_statement.expenditures.build(name: 'Rent', amount: 2000)
      ie_statement.save
      expect(ie_statement.disposable_income).to eq(3000)
    end

    it 'calculates rating before save' do
      ie_statement.incomes.build(name: 'Job', amount: 5000)
      ie_statement.expenditures.build(name: 'Rent', amount: 2000)
      ie_statement.save
      expect(ie_statement.rating).to eq('C')
    end
  end

  describe '#add_incomes' do
  	let(:ie_statement) { create(:ie_statement) }

    it 'adds multiple incomes to the ie_statement' do
      incomes_list = [
        { 'name' => 'Job', 'amount' => 5000 },
        { 'name' => 'Freelance', 'amount' => 2000 }
      ]
      ie_statement.add_incomes(incomes_list)
      expect(ie_statement.incomes.count).to eq(2)
      expect(ie_statement.total_income).to eq(7000)
    end
  end

  describe '#add_expenditures' do
  	let(:ie_statement) { create(:ie_statement) }

    it 'adds multiple expenditures to the ie_statement' do
      expenditures_list = [
        { 'name' => 'Rent', 'amount' => 2000 },
        { 'name' => 'Groceries', 'amount' => 500 }
      ]
      ie_statement.add_expenditures(expenditures_list)
      expect(ie_statement.expenditures.count).to eq(2)
      expect(ie_statement.total_expenditure).to eq(2500)
    end
  end
end

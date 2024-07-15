# spec/factories/ie_statements.rb
FactoryBot.define do
  factory :ie_statement do
    association :user

    total_income { 0.0 }
    total_expenditure { 0.0 }
    disposable_income { 0.0 }
    rating { "D" }
    month { Date::MONTHNAMES.compact.sample.downcase }
	end

	trait :incomes_and_expenditures do
    after(:build) do |ie_statement|
      ie_statement.incomes << build_list(:income, 3, ie_statement: ie_statement)
      ie_statement.expenditures << build_list(:expenditure, 3, ie_statement: ie_statement)
    end
  end
end

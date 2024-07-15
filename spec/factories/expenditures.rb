FactoryBot.define do
  factory :expenditure do
    name { "Rent" }
    amount { 500.0 }
    association :ie_statement
  end
end

FactoryBot.define do
  factory :income do
    name { "Job" }
    amount { 1000.0 }
    association :ie_statement
  end
end

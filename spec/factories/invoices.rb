FactoryBot.define do
  factory :invoice do
    status { "MyString" }
    customers { nil }
    merchants { nil }
  end
end

FactoryBot.define do
  factory :item do
    name { "MyString" }
    description { "MyString" }
    unit_price { 1.5 }
    merchants { nil }
  end
end

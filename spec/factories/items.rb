FactoryBot.define do
  factory :item do
    name { Faker::Coffee.blend_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.number(digits: 4) }

    association :merchant
  end
end


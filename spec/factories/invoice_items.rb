FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    unit_price { 1.5 }
    items { nil }
    invoices { nil }
  end
end

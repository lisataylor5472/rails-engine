class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of(:name)
  validates_presence_of(:description)
  validates_presence_of(:unit_price)
  validates :unit_price, numericality: { greater_than: 0.0 }
  validates :merchant_id, numericality: true
end

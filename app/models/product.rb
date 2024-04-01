class Product < ApplicationRecord
  self.primary_key = "code"

  has_many :percentage_discounts

  validates :price, presence: true, numericality: { greater_than: 0 }
end

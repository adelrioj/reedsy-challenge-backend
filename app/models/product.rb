class Product < ApplicationRecord
  self.primary_key = "code"

  validates :price, presence: true, numericality: { greater_than: 0 }
end

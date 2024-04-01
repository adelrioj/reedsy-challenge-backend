class PercentageDiscount < ApplicationRecord
  belongs_to :product, foreign_key: :product_code, primary_key: :code

  validates :quantity_threshold, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end

# frozen_string_literal: true

class Cart
  def initialize(product_codes)
    @products = cart_from(product_codes)
  end

  def calculate_total
    @products.inject(0.0) do |total, (code, quantity)|
      total + calculate_price_single_product(code, quantity)
    end
  end

  def to_string
    @products.map { |product, qty| "#{qty} #{product}" }.join(', ')
  end

  private

  def cart_from(product_codes)
    product_codes.each_with_object(Hash.new(0)) do |code, products|
      next unless inventory.key?(code)

      products[code] = products[code] + 1
    end
  end

  def calculate_price_single_product(code, quantity)
    price = inventory[code]
    discount = find_applicable_discount(code, quantity)
    price -= price * (discount.percentage / 100.0) if discount

    price * quantity
  end

  def find_applicable_discount(code, quantity)
    discounts[code]&.select do |discount|
      quantity >= discount.quantity_threshold
    end&.max_by(&:percentage)
  end

  def inventory
    @inventory ||= Product.pluck(:code, :price).to_h
  end

  def discounts
    @discounts ||= PercentageDiscount.all.group_by(&:product_code)
  end
end

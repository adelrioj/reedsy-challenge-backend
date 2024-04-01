class PriceController < ApplicationController
  # POST /total_price
  def total_price
    product_codes = params.require(:product_codes)
    cart = Cart.new(product_codes)
    response = {
      items: cart.to_string,
      total: cart.calculate_total
    }

    render json: response
  end
end

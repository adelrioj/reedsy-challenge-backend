class ProductsController < ApplicationController
  # GET /products
  def index
    @products = Product.all

    render json: @products.as_json(only: %i[code name price])
  end
end

class ProductsController < ApplicationController
  before_action :set_product, only: [:update]

  # GET /products
  def index
    @products = Product.all

    render json: @products.as_json(only: %i[code name price])
  end

  # PATCH /products/:id
  def update
    if @product.update(product_params)
      render json: @products.as_json(only: %i[code name price])
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:price)
  end
end

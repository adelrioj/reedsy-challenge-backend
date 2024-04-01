require 'rails_helper'

RSpec.describe "/products", type: :request do

  let(:valid_attributes) {
    {
      code: "MUG",
      name: "Reedsy Mug",
      price: "6.0"
    }

  }

  describe "GET /index" do
    before { Product.create! valid_attributes }
    it "renders a successful response" do
      get products_url, as: :json

      expect(response).to be_successful
    end

    it "retrieves correct data" do
      get products_url, as: :json

      expect(response.body).to eq([valid_attributes].to_json)
    end
  end
end

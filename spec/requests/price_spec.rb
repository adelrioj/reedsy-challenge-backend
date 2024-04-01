require 'rails_helper'

RSpec.describe '/total_price', type: :request do
  before do
    Product.create!(code: 'MUG', price: 6.0)
    Product.create!(code: 'TSHIRT', price: 15.0)
    Product.create!(code: 'HOODIE', price: 20.0)
  end

  context 'when a code does not exist' do
    let(:product_codes) { %w[MUG NOEXIST HOODIE] }
    let(:total_price) do
      {
        items: '1 MUG, 1 HOODIE',
        total: '26.0'
      }
    end

    it 'ignores the code' do
      post total_price_url, params: { product_codes: product_codes }, as: :json

      expect(response.body).to eq(total_price.to_json)
    end
  end

  context 'with no discounts' do
    let(:product_codes) { %w[MUG TSHIRT HOODIE] }
    let(:total_price) do
      {
        items: '1 MUG, 1 TSHIRT, 1 HOODIE',
        total: '41.0'
      }
    end

    it 'returns the total price' do
      post total_price_url, params: { product_codes: product_codes }, as: :json

      expect(response.body).to eq(total_price.to_json)
    end
  end

  context "with discounts" do
    before do
      PercentageDiscount.create!(product_code: "TSHIRT", quantity_threshold: 3, percentage: 30)
      (1..15).each do |index|
        PercentageDiscount.create!(product_code: "MUG", quantity_threshold: index * 10, percentage: index * 2)
      end
    end

    context "when 9 MUG, 1 TSHIRT" do
      let(:product_codes) do
        Array.new(9) { "MUG" }.concat(%w[TSHIRT])
      end
      let(:total_price) do
        {
          items: '9 MUG, 1 TSHIRT',
          total: '69.0'
        }
      end

      it 'returns the total price' do
        post total_price_url, params: { product_codes: product_codes }, as: :json

        expect(response.body).to eq(total_price.to_json)
      end
    end

    context "when 10 MUG, 1 TSHIRT" do
      let(:product_codes) do
        Array.new(10) { "MUG" }.concat(%w[TSHIRT])
      end
      let(:total_price) do
        {
          items: '10 MUG, 1 TSHIRT',
          total: '73.8'
        }
      end

      it 'returns the total price' do
        post total_price_url, params: { product_codes: product_codes }, as: :json

        expect(response.body).to eq(total_price.to_json)
      end
    end

    context "when 45 MUG, 3 TSHIRT" do
      let(:product_codes) do
        Array.new(45) { "MUG" }.concat(%w[TSHIRT TSHIRT TSHIRT])
      end
      let(:total_price) do
        {
          items: '45 MUG, 3 TSHIRT',
          total: '279.9'
        }
      end

      it 'returns the total price' do
        post total_price_url, params: { product_codes: product_codes }, as: :json

        expect(response.body).to eq(total_price.to_json)
      end
    end

    context "when 200 MUG, 4 TSHIRT, 1 HOODIE" do
      let(:product_codes) do
        Array.new(200) { "MUG" }.concat(%w[TSHIRT TSHIRT TSHIRT TSHIRT HOODIE])
      end
      let(:total_price) do
        {
          items: '200 MUG, 4 TSHIRT, 1 HOODIE',
          total: '902.0'
        }
      end

      it 'returns the total price' do
        post total_price_url, params: { product_codes: product_codes }, as: :json

        expect(response.body).to eq(total_price.to_json)
      end
    end
  end
end

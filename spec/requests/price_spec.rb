require 'rails_helper'

RSpec.describe '/total_price', type: :request do
  let(:product_codes) { %w[MUG TSHIRT HOODIE] }
  let(:total_price) do
    {
      items: '1 MUG, 1 TSHIRT, 1 HOODIE',
      total: '41.0'
    }
  end

  before do
    Product.create!(code: 'MUG', price: 6.0)
    Product.create!(code: 'TSHIRT', price: 15.0)
    Product.create!(code: 'HOODIE', price: 20.0)
  end
  before { post total_price_url, params: { product_codes: product_codes }, as: :json }

  it 'returns the total price' do
    expect(response.body).to eq(total_price.to_json)
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
      expect(response.body).to eq(total_price.to_json)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceController, type: :controller do
  let(:product_codes) { ['MUG', 'TSHIRT', 'HOODIE'] }
  let(:total_price) { 41.0 }
  let(:items) { '1 MUG, 1 TSHIRT, 1 HOODIE' }
  let(:expected_response) do
    {
      items: '1 MUG, 1 TSHIRT, 1 HOODIE',
      total: 41.0
    }.to_json
  end

  let(:cart) { instance_double('Cart') }

  before do
    allow(Cart).to receive(:new).with(product_codes).and_return(cart)
    allow(cart).to receive(:calculate_total).and_return(total_price)
    allow(cart).to receive(:to_string).and_return(items)
  end

  describe 'POST #total_price' do
    before do
      post :total_price, params: { product_codes: product_codes }
    end

    it 'calls Cart to calculate the price' do
      expect(cart).to have_received(:calculate_total)
    end

    it 'calls Cart to generate the items string' do
      expect(cart).to have_received(:to_string)
    end

    it 'returns the total price' do
      expect(response.body).to eq(expected_response)
    end
  end
end

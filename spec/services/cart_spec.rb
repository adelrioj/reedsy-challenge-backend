# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart do
  before do
    Product.create!(code: 'MUG', price: 6.00)
    Product.create!(code: 'TSHIRT', price: 15.00)
    Product.create!(code: 'HOODIE', price: 20.00)
  end

  describe '#calculate_total' do
    subject { described_class.new(product_codes).calculate_total }

    context 'when product_codes is empty' do
      let(:product_codes) { [] }

      it 'returns the proper total price' do
        expect(subject).to eq(0.0)
      end
    end

    context 'when a code does not exist' do
      let(:product_codes) { %w[MUG NOEXIST HOODIE] }

      it 'ignores the code' do
        expect(subject).to eq(26.0)
      end
    end

    context 'when one of each' do
      let(:product_codes) { %w[MUG TSHIRT HOODIE] }

      it 'returns the proper total price' do
        expect(subject).to eq(41.0)
      end
    end

    context 'when multiple of each' do
      let(:product_codes) { %w[MUG MUG TSHIRT TSHIRT HOODIE HOODIE] }
      let(:expected_response) do
        {
          items: '2 MUG, 2 TSHIRT, 2 HOODIE',
          total: 82.0
        }
      end

      it 'returns the proper total price' do
        expect(subject).to eq(82)
      end
    end
  end

  describe '#products_as_string' do
    let(:product_codes) { %w[MUG MUG TSHIRT TSHIRT HOODIE HOODIE] }

    subject { described_class.new(product_codes).to_string }

    it 'returns the proper string' do
      expect(subject).to eq('2 MUG, 2 TSHIRT, 2 HOODIE')
    end
  end
end

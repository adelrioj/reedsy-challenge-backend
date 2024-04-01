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

    context 'with no discounts' do
      let(:product_codes) { %w[MUG MUG TSHIRT TSHIRT HOODIE HOODIE] }

      it 'returns the sum of all prices' do
        expect(subject).to eq(82)
      end
    end

    context 'with discounts' do
      context "when there is one discount in one product" do
        before do
          PercentageDiscount.create!(product_code: "MUG", quantity_threshold: 10, percentage: 2)
        end

        let(:product_codes) do
          Array.new(10) { "MUG" }.concat(%w[TSHIRT])
        end

        it 'returns the sum of all prices' do
          expect(subject).to eq(73.8)
        end
      end

      context "when there are multiple discounts in one product" do
        before do
          (1..15).each do |index|
            PercentageDiscount.create!(product_code: "MUG", quantity_threshold: index * 10, percentage: index * 2)
          end
        end

        let(:product_codes) do
          Array.new(45) { "MUG" }.concat(%w[TSHIRT TSHIRT TSHIRT])
        end

        it 'returns the sum of all prices' do
          expect(subject).to eq(293.4)
        end
      end

      context "when there are one or more discounts in multiple products" do
        before do
          PercentageDiscount.create!(product_code: "TSHIRT", quantity_threshold: 3, percentage: 30)
          (1..15).each do |index|
            PercentageDiscount.create!(product_code: "MUG", quantity_threshold: index * 10, percentage: index * 2)
          end
        end

        let(:product_codes) do
          Array.new(45) { "MUG" }.concat(%w[TSHIRT TSHIRT TSHIRT])
        end

        it 'returns the sum of all prices' do
          expect(subject).to eq(279.90)
        end
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

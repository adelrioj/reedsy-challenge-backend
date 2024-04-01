require 'rails_helper'

RSpec.describe '/products', type: :request do
  let(:valid_attributes) {
    {
      code: 'MUG',
      name: 'Reedsy Mug',
      price: '6.0'
    }
  }
  let!(:product) { Product.create! valid_attributes }

  describe 'GET /index' do
    it 'renders a successful response' do
      get products_url, as: :json

      expect(response).to be_successful
    end

    it 'retrieves correct data' do
      get products_url, as: :json

      expect(response.body).to eq([valid_attributes].to_json)
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          price: 2.0
        }
      end

      it 'updates the requested product' do
        patch product_url(product), params: { product: new_attributes }, as: :json

        product.reload
        expect(product.price).to eq(2.0)
      end

      it 'renders a JSON response with the product' do
        patch product_url(product), params: { product: new_attributes }, as: :json

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      context 'validates numericality of price' do
        let(:invalid_attributes) do
          {
            price: 'invalid price'
          }
        end

        it 'renders a JSON response with errors for the product' do
          patch product_url(product), params: { product: invalid_attributes }, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'validates presence of price' do
        let(:invalid_attributes) do
          {
            price: nil
          }
        end

        it 'renders a JSON response with errors for the product' do
          patch product_url(product), params: { product: invalid_attributes }, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when providing a different attribute than price' do
        let(:invalid_attributes) do
          {
            name: 'New Name'
          }
        end

        it 'does not update the attribute' do
          patch product_url(product), params: { product: invalid_attributes }, as: :json

          product.reload
          expect(product.name).to eq('Reedsy Mug')
        end
      end
    end
  end
end

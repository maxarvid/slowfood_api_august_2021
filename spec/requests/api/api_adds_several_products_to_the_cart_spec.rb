RSpec.describe 'PUT /api/carts', type: :request do
  subject { response }
  let(:product_existing) { create(:product, name: 'Kangaroo Steak') }
  let(:product) { create(:product, name: 'Whale Blubber Stew') }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user_id: user.id) }
  let(:auth_headers) { user.create_new_auth_token }
  describe 'authorized user can add products to an existing cart' do
    before do
      cart.cart_products.create(product_id: product_existing.id)
      put "/api/carts/#{cart.id}",
          params: {
            product_id: product.id
          },
          headers: auth_headers
    end

    it { is_expected.to have_http_status 200 }

    it 'is expected to return an array of items' do
      expect(response_json['cart']['products'].count).to eq 2
    end

    it('is expected that the second product is added to the cart') do
      expect(response_json['message']).to eq(
        'Whale Blubber Stew was added to your cart!'
      )
    end
  end

  describe 'unauthorized user can not create cart ' do
    before do
      post '/api/carts',
           params: {
             product_id: product.id
           },
           headers: {}
    end

    it { is_expected.to have_http_status 401 }

    it 'is expected to show error message' do
      expect(response_json['errors']).to eq ['You need to sign in or sign up before continuing.']
    end
  end

  describe 'unsuccesful request with invalid product id' do
    before do
      post '/api/carts',
           params: {
             product_id: 999
           },
           headers: auth_headers
    end
    it { is_expected.to have_http_status 422 }
    it 'is expected to show error message:' do
      expect(response_json['message']).to eq 'We could not process your request.'
    end
  end
end

RSpec.describe 'PUT /api/carts/:id', type: :request do
  subject { response }
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:product_1) { create(:product, name: 'Kangaroo Steak') }
  let(:product_2) { create(:product) }
  let(:cart) { create(:cart, user: user, products: [product_1, product_2]) }

  describe 'the request includes a valid cart id' do
    before do
      Timecop.freeze(Time.local(2021, 9, 1, 20, 30, 0))
      put "/api/carts/#{cart.id}",
          params: {
            finalized: true,
          },
          headers: auth_headers
    end

    it { is_expected.to have_http_status 200 }

    it 'is expected to update cart#finalized to "true"' do
      expect(cart.reload.finalized?).to eq true
    end

    it 'is expected to include delivery time message' do
      expect(response_json['message']).to eq 'Your order is ready for pickup at 21:00'
    end

    it 'is expected to include finalized key with a value "true"' do
      expect(response_json['cart']).to have_key('finalized').and have_value(true)
    end
  end

  describe 'the request does not includes a valid cart id' do
    before do
      Timecop.freeze(Time.local(2021, 9, 1, 20, 30, 0))
      put '/api/carts/999',
          params: {
            finalized: true,
          },
          headers: auth_headers
    end

    it { is_expected.to have_http_status 422 }

    it 'is expected to show an error message' do
      expect(response_json['message']).to eq 'We could not process your request.'
    end
  end
end

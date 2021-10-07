RSpec.describe 'PUT /api/carts/:id', type: :request do
  subject { response }
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:product_1) { create(:product, name: 'Kangaroo Steak') }
  let(:cart) { create(:cart, user: user, products: [product_1]) }
  
  before do
    put "/api/carts/#{cart.id}",
        params: {
          finalized: true,
          cart: cart.id
        },
        headers: auth_headers
  end

  it { is_expected.to have_http_status 200 }

  it 'is expected to update cart#finalized to "true"' do
    cart.reload
    expect(cart.finalized).to eq true
  end

  it 'is expected to include delivery time message' do
    # arrange that time of request is 11:30 AM
    expect(response_json['message']).to eq 'Your order in ready for pick-up at 12:00 PM'
  end
end

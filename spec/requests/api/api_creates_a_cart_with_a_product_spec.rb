RSpec.describe 'POST /api/carts', type: :request do
  subject { response }
  let(:product) { create(:product, name: 'Kangaroo Steak') }
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  describe 'authorized user can create an cart' do
    before do
      post '/api/carts',
           params: {
             product_id: product.id,
           },
           headers: auth_headers
    end

    it { is_expected.to have_http_status 201 }

    it 'is expected to return a message' do
      expect(response_json['message']).to eq(
        'Kangaroo Steak was added to your cart!'
      )
    end

    it 'is expected to return a cart id' do
      expect(response_json['cart']['id']).to_not eq nil
    end

    it 'is expected to return an array of items' do
      expect(response_json['cart']['products'].count).to eq 1
    end

    it 'is expected to include finalized key with a value "false"' do
      expect(response_json['cart']).to have_key('finalized').and have_value(false)
    end
  end

  describe 'unauthorized user can not create cart ' do
    before do
      post '/api/carts',
           params: {
             product_id: product.id,
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
             product_id: 999,
           },
           headers: auth_headers
    end

    it { is_expected.to have_http_status 422 }

    it 'is expected to show error message:' do
      expect(response_json['message']).to eq 'We could not process your request.'
    end
  end
end

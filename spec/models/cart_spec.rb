RSpec.describe Cart, type: :model do
  describe 'cart table' do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :user_id }
    it {
      is_expected.to have_db_column(:finalized)
                       .of_type(:boolean)
    }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:cart_products) }
    it {
      is_expected.to have_many(:products)
                       .through(:cart_products)
    }
  end

  describe 'Factory' do
    it 'is expected to be valid' do
      expect(create(:cart)).to be_valid
    end
  end

  describe 'instance methods' do
    it { is_expected.to respond_to :finalized? }
  end
end

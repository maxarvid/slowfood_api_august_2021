class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_products
  has_many :products, through: :cart_products

  DEFAULT_DELIVERY_TIME_IN_MINUTES = 30.minutes

  def finalized?
    finalized
  end
end

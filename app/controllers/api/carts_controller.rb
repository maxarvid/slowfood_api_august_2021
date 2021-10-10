class Api::CartsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :get_cart, only: :update
  before_action :finalize_order, only: :update

  def create
    product = Product.find(params['product_id'])
    @cart = current_user.carts.create
    @cart.cart_products.create(product_id: product.id)
    render_response("#{product.name} was added to your cart!", 201)
  end

  def update
    product = Product.find(params['product_id'])
    @cart.cart_products.create(product_id: product.id)
    render_response("#{product.name} was added to your cart!", 200)
  end

  private

  def finalize_order
    if params[:finalized] && @cart.update(finalized: params[:finalized])
      message = "Your order is ready for pickup at #{(Time.now + Cart::DEFAULT_DELIVERY_TIME_IN_MINUTES).to_s(:time)}"
      render_response(message, 200) and return
    end
  end

  def get_cart
    @cart = Cart.find(params[:id])
  end

  def render_response(message, status)
    render json: {
      message: message,
      cart: {
        id: @cart.id,
        finalized: @cart.finalized?,
        products: @cart.products,
      },
    }, status: status
  end
end

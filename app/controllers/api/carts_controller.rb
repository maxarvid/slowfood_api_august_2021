class Api::CartsController < ApplicationController
  before_action :authenticate_user!, only: :create
  rescue_from ActiveRecord::RecordNotFound, with: :custom_error

  def create
    product = Product.find(params['product_id'])
    cart = current_user.carts.create
    cart.cart_products.create(product_id: product.id)
    render_response(cart, "#{product.name} was added to your cart!", 201)
  end

  def update
    cart = Cart.find(params['id'])
    if params[:finalized] && cart.update(finalized: params[:finalized])
      message = "Your order is ready for pickup at #{(Time.now + Cart::DEFAULT_DELIVERY_TIME_IN_MINUTES).to_s(:time)}"
      render_response(cart, message, 200) and return
    end
    product = Product.find(params['product_id'])
    cart.cart_products.create(product_id: product.id)
    render_response(cart, "#{product.name} was added to your cart!", 200)
  end

  private

  def custom_error
    render json: { message: 'We could not process your request.' }, status: 422
  end

  def render_response(cart, message, status)
    render json: {
      message: message,
      cart: {
        id: cart.id,
        products: cart.products
      }
    }, status: status
  end
end

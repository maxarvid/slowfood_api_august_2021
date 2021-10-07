class Api::CartsController < ApplicationController
  before_action :authenticate_user!, only: :create
  rescue_from ActiveRecord::RecordNotFound, with: :custom_error

  def create
    product = Product.find(params["product_id"])
    cart = current_user.carts.create
    cart.cart_products.create(product_id: product.id)
    render_response(cart, "#{product.name} was added to your cart!", 201)
  end

  def update
    cart = Cart.find(params["id"])    
    if params[:finalized]
      cart.update(finalized: params[:finalized])
      render_response(cart, "Your order is ready for pickup at #{30.minutes.from_now.to_s(:time)}", 200) and return
    end
    product = Product.find(params["product_id"])
    cart.cart_products.create(product_id: product.id)
    render_response(cart, "#{product.name} was added to your cart!", 200)
  end

  private

  def custom_error
    render json: { message: "Product not found!" }, status: 422
  end

  def render_response(cart, message, status)
    render json: {
      message: message,
      cart: {
        id: cart.id,
        products: cart.products,
      },
    }, status: status
  end
end

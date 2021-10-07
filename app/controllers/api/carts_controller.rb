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
    binding.pry
    params[:finalized] && render_response(cart, "some message", 200) and return
    new_product = Product.find(params["product_id"])
    cart.cart_products.create(product_id: new_product.id)
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

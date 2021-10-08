class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound, with: :custom_error

  private

  def custom_error
    render json: { message: "We could not process your request." }, status: 422
  end
end

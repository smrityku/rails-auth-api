class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]

  def signup
    user = User.create!(user_params)
    render json: { message: "User created", user: { id: user.id, email: user.email } }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id, role: user.role)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password, :role)
  end
end

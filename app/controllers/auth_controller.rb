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
    if user && !user.verified
      return render json: { error: "Account not verified" }, status: :unauthorized
    end

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id, role: user.role)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def send_otp
    user = User.find_by(email: params[:email])

    return render json: { error: "User not found" }, status: :not_found unless user

    user.generate_otp

    # OTP is exposed in response for developmental purpose only
    render json: { message: "OTP sent successfully", otp: user.otp }
  end

  def verify_otp
    user = User.find_by(email: params[:email])

    return render json: { error: "User not found" }, status: :not_found unless user

    if user.otp_valid?(params[:otp])
      user.update!(verified: true, otp: nil)
      render json: { message: "OTP verified successfully" }
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:auth).permit(:email, :password, :role)
  end
end

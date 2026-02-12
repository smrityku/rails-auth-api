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

    return render json: { error: "Invalid credentials" }, status: :unauthorized unless user&.authenticate(params[:password])

    access_token = JsonWebToken.encode(
      { user_id: user.id },
      15.minutes.from_now
    )

    refresh_token = SecureRandom.hex(32)

    user.update!(
      refresh_token: refresh_token,
      refresh_token_expires_at: 7.days.from_now
    )

    render json: {
      access_token: access_token,
      refresh_token: refresh_token
    }
  end

  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])

    return render json: { error: "Invalid refresh token" }, status: :unauthorized unless user
    return render json: { error: "Refresh token expired" }, status: :unauthorized if user.refresh_token_expires_at < Time.current

    access_token = JsonWebToken.encode(
      { user_id: user.id },
      15.minutes.from_now
    )

    render json: { access_token: access_token }
  end

  def logout
    current_user.update!(
      refresh_token: nil,
      refresh_token_expires_at: nil
    )

    render json: { message: "Logged out successfully" }
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

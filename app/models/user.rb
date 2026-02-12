class User < ApplicationRecord
  has_secure_password

  enum :role, { user: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true

  OTP_VALIDITY = 10.minutes

  def generate_otp
    update!(
      otp: rand(100000..999999).to_s,
      otp_sent_at: Time.current
    )
  end

  def otp_valid?(entered_otp)
    return false if otp != entered_otp
    return false if otp_sent_at < OTP_VALIDITY.ago

    true
  end
end

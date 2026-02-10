class User < ApplicationRecord
  has_secure_password

  enum role: { 'user': 0, 'admin': 1 }, _prefix: :role

  validates :email, presence: true, uniqueness: true

  def generate_otp
    update!(
      otp: rand(100000..999999).to_s,
      otp_sent_at: Time.current
    )
  end
end

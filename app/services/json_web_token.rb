class JsonWebToken
  SECRET = ENV["JWT_SECRET_KEY"]

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new decoded
  rescue
    nil
  end
end

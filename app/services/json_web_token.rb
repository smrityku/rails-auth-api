class JsonWebToken
  SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def self.encode(payload, exp)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end
end

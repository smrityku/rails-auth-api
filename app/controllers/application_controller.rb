class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded

    render_unauthorized unless @current_user
  rescue ActiveRecord::RecordNotFound
    render_unauthorized
  end

  def authorize_admin!
    render json: { error: "Forbidden. Admin access only." }, status: :forbidden unless current_user.admin?
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end

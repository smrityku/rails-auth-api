class AdminController < ApplicationController
  before_action :authorize_admin!

  def dashboard
    render json: {
      message: "Welcome Admin",
      total_users: User.count
    }
  end
end

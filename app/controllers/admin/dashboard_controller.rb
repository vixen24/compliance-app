class Admin::DashboardController < ApplicationController
  include Admin::Authentication
  before_action :authenticate_admin!

  layout "admin"

  def show
    @metrics = Admin::Dashboard.new(Current.user.account).call
  end
end

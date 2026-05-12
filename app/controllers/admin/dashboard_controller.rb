class Admin::DashboardController < ApplicationController
  admin_access_only

  layout "admin"

  def show
    @metrics = Admin::Dashboard.new(Current.account).call
  end
end

class Admin::DashboardController < ApplicationController
  admin_access_only
  layout "public"

  def show
    @metrics = Admin::Dashboard.new(Current.user.account).call
  end
end

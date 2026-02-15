class Admin::DashboardController < ApplicationController
  include Admin::Authentication
  before_action :authenticate_admin!

  layout "admin"

  def show
    @metrics = {
      users: User.count,
      teams: Team.count,
      users_without_team: User.where.missing(:team_users).count,
      active_sessions: Session.count
    }

    @storage_used   = System::Storage.used_bytes
    @storage_total  = System::Storage.total_bytes
    @storage_percent = System::Storage.percent_used
  end

  private
end

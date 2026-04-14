class HomeController < ApplicationController
  def show
    user = Current.user

    if user.admin?
      redirect_to admin_dashboard_path
      return
    end

    if user.executive?
      redirect_to executive_group_dashboard_path
      return
    end

    team = Current.team || user.teams.first

    if team.present?
      redirect_to team_dashboard_path(team)
    else
      render :pending
    end
  end
end

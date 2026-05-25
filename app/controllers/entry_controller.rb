class EntryController < ApplicationController
  skip_before_action :require_account
  def show
    user = Current.user

    if user.admin?
      redirect_to admin_dashboard_path(script_name: user.account.slug)
      return
    end

    if user.executive?
      redirect_to executive_group_dashboard_path(script_name: user.account.slug)
      return
    end

    team = Current.team || user.teams.order(:name).first

    if team.present?
      redirect_to team_dashboard_path(team, script_name: user.account.slug)
    else
      render :pending
    end
  end

  def index
  end
end

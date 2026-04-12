class CurrentTeamController < ApplicationController
  def update
    Current.team = Current.user.teams.find(params[:id])
    redirect_to team_dashboard_path(Current.team)
  end
end

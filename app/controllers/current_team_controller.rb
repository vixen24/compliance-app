class CurrentTeamController < ApplicationController
  def update
    team = Current.user.teams.find(params[:id])
    # session[:current_team_id] = team.id
    Current.team = team
    redirect_to team_dashboard_path(team)
  end
end

class CurrentTeamController < ApplicationController
  def update
    Current.team = Current.user.teams.find_by!(slug: params[:team_slug])
    redirect_to team_dashboard_path(Current.team, status: params[:status])
  end
end

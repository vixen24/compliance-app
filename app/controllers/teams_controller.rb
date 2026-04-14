class TeamsController < ApplicationController
  admin_access_only
  before_action :set_team, only: %i[edit update destroy]
  before_action :set_users, only: %i[new edit create update]

  layout "admin"

  def index
    @teams = Current.user.account.teams.includes(:users, :assessments).order(:name)
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      respond_to do |format|
        format.html { redirect_to teams_path, notice: "Team created successfully" }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, teams_path) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      respond_to do |format|
        format.html { redirect_to teams_path, notice: "Team updated successfully." }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, teams_path) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "Deleted successfully."
  end

  private

  def set_users
    @users = Current.user.account.users.regular
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :account_id, user_ids: [])
  end
end

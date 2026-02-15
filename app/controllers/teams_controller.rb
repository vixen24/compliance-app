class TeamsController < ApplicationController
  include Admin::Authentication

  before_action :authenticate_admin!
  before_action :set_team, only: :update
  before_action :set_users, only: %i[new edit create update]

  layout "admin"

  def index
    @teams = Current.user.account.teams.includes(:users, :assessments).order(:name)
  end

  def new
    @team = Team.new
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to teams_path, notice: "Team created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      redirect_to teams_path, notice: "Team updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_users
    @users = Current.user.account.users.member_or_admin
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :account_id, user_ids: [])
  end
end

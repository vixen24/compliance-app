class Admin::UsersController < ApplicationController
  admin_access_only
  before_action :set_user, only: [ :edit, :update, :destroy ]
  before_action :set_team, only: [ :index ]
  before_action :set_active, only: [ :index ]
  before_action :set_role, only: [ :index ]
  before_action :set_search_param, only: [ :index ]
  before_action :set_teams, only: [ :new, :edit, :create, :update ]
  before_action :set_password_reset, only: [ :new, :edit, :create, :update ]

  layout "public"

  def index
    @users = Current.user.account.users.matching(@q).by_active(@active).by_team(@team).by_role(@role).order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new()
  end

  def create
    @user = Current.user.account.users.new(user_params)

    if @user.save
      PasswordsMailer.reset(@user).deliver_later
      flash.now[:notice] = "User created"

      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "User created" }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = params[:toggle] ? { active: !@user.active } : user_params

    if @user.update(attrs)
      flash.now[:notice] = "User updated"

      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "User updated" }
        format.turbo_stream
      end
    else
      if params[:toggle]
        redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end


  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "User deleted successfully."
    else
      redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def set_search_param
    @q = params[:q] if params[:q].present?
  end

  def set_active
    @active = params[:active]
  end

  def set_role
    @role = params[:role]
  end

  def set_password_reset
    @password_reset = ActiveModel::Type::Boolean.new.cast(params[:password_reset])
  end

  def set_teams
    @teams = Current.user.account.teams
  end

  def set_team
    @team = Team.find_by(id: params[:team]) if params[:team].present?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation, :country, :role, team_ids: [] ])
  end
end

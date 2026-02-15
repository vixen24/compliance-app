class Admin::UsersController < ApplicationController
  include Admin::Authentication
  before_action :authenticate_admin!, only: [ :index, :new, :create, :edit, :update, :destroy ]
  before_action :set_user, only: [ :edit, :update, :destroy ]
  before_action :set_team, only: [ :index ]


  layout "admin"

  def index
    @users = Current.user.account.users.by_team(@team).order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = Current.user.account.users.new(user_params)

    if @user.save
      PasswordsMailer.reset(@user).deliver_later
      redirect_to admin_users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    Current.user.valid?
    if @user.errors.any?
      flash.now[:alert] = @user.errors.full_messages.to_sentence
    end
  end

  def update
    attrs = params[:toggle] ? { active: !@user.active } : user_params

    if @user.update(attrs)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      if params[:toggle]
        redirect_back(fallback_location: admin_users_path, alert: @user.errors.full_messages.to_sentence)
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

  def set_team
    @team = Team.find_by(id: params[:team]) if params[:team].present?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation, :country, :role,  team_ids: [] ])
  end
end

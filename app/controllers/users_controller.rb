class UsersController < ApplicationController
  before_action :set_current_team, only: [ :show, :destroy ]
  before_action :set_user, only: [ :destroy ]
  before_action :check_permission, if: -> { action_name.in?(%w[new create edit update]) }

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = Current.user.account.users.new(user_params)

    if @user.save
      PasswordsMailer.reset(@user).deliver_later
      redirect_to users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = params[:toggle] ? { active: !@user.active } : user_params.to_h

    if @user.update(attrs)
      redirect_to users_path, notice: "User updated successfully."
    else
      params[:toggle] ? redirect_back(fallback_location: users_path, alert: @user.errors.full_messages.to_sentence) : render(:edit)
    end
  end


  def destroy
    if @user.destroy
      redirect_to users_path, notice: "User deleted successfully."
    else
      redirect_to users_path, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation, :country, :role,  team_ids: [] ])
  end

  def check_permission
    redirect_back(fallback_location: root_path, alert: "Action not allowed")
  end
end

class Executive::UsersController < ApplicationController
  executive_access_only
  before_action :set_user, only: [ :show ]

  def show
  end


  private

  def set_user
    @user = User.find(params[:id])
  end
end

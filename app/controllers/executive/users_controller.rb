class Executive::UsersController < ApplicationController
  include Executive::Authentication

  before_action :authorize_executive!
  before_action :set_user, only: [ :show ]

  def show
  end


  private

  def set_user
    @user = User.find(params[:id])
  end
end

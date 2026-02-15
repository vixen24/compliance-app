class Admin::SessionsController < ApplicationController
  include Admin::Authentication

  before_action :authenticate_admin!
  before_action :set_session, only: [ :destroy ]

  layout "admin"

  def index
    @sessions = Current.user.account.sessions
  end

  def destroy
    @session.destroy
    redirect_back fallback_location: session_path, notice: "User session terminated"
  end

  private

  def set_session
    @session = Session.find(params[:id])
  end
end

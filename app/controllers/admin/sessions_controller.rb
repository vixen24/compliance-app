class Admin::SessionsController < ApplicationController
  admin_access_only
  before_action :set_search_param, only: [ :index ]
  before_action :set_session, only: [ :destroy ]

  layout "public"

  def index
    @sessions = Current.user.account.sessions.matching(@q).includes(:user).order(:user_id)
  end

  def destroy
    if params[:all]
      Current.user.account.sessions.where.not(id: Current.session.id).destroy_all
      notice = "All sessions terminated"
    else
      @session.destroy
      notice = "Session terminated"
    end

    redirect_to admin_sessions_path, notice: notice
  end

  private

  def set_search_param
    @q = params[:q] if params[:q].present?
  end

  def set_session
    @session = Session.find(params[:id]) if params[:id].present?
  end
end

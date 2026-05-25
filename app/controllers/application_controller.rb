class ApplicationController < ActionController::Base
  include Authentication
  include Admin::Authorization
  include Executive::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_current_team
    Current.team = Current.user.teams.find_by(slug: params[:team_slug])
    redirect_to entry_url(script_name: Current.account.slug) unless Current.team
  end
end

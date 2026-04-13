class SessionsController < ApplicationController
  require_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  layout "public"
  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    return invalid_credentials unless user
    return inactive_account unless user.active?
    return require_mfa(user) if user.account.mfa_enabled?

    sign_in(user)
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  private

  def invalid_credentials
    redirect_to new_session_path, alert: "Try another email address or password"
  end

  def inactive_account
    redirect_to new_session_path, alert: "Inactive account. Contact administrator"
  end

  def require_mfa(user)
    redirect_to_session_magic_link(user.send_magic_link(for: :sign_in))
  end

  def sign_in(user)
    start_new_session_for(user)
    redirect_to after_authentication_url
  end
end

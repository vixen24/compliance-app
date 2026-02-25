class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user&.active
        redirect_to_session_magic_link(user.send_magic_link(for: :sign_in))
    else
      message = user ? "Inactive account. Contact administrator" : "Try another email address or password"
      redirect_to new_session_path, alert: message
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end

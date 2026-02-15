class SignUpsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  # before_action :ensure_signup_allowed, only: [ :new, :create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_sign_up_path, alert: "Try again later." }
  def new
    @signup = SignUp.new
  end

  def create
     @signup = SignUp.new(signup_params)

     if @signup.create_account
      redirect_to_session_magic_link(@signup.user.send_magic_link(for: :sign_up))
     else
      render :new, status: :unprocessable_entity
     end
  end

  private

  def signup_params
    params.expect(sign_up: [ :email_address, :password, :password_confirmation ])
  end

  def ensure_signup_allowed
    return if User.signup_enabled?
    redirect_to root_path, alert: "Sign up is disabled. Contact an admin."
  end
end

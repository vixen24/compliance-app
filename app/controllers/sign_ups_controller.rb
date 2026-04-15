class SignUpsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_sign_up_path, alert: "Try again later." }
  allow_unauthenticated_access only: %i[ new create ]
  before_action :ensure_signup_allowed, only: %i[ new create ]

  layout "public"

  def new
    @signup = SignUp.new
  end

  def create
     @signup = SignUp.new(signup_params)

     if @signup.create_account
      start_new_session_for(@signup.user)
      redirect_to admin_dashboard_path
     else
      render :new, status: :unprocessable_entity
     end
  end

  private

  def signup_params
    params.expect(sign_up: [ :email_address, :password, :password_confirmation ])
  end

  def ensure_signup_allowed
    return if Account.accepting_signups
    redirect_to root_path, alert: "Signups not allowed"
  end
end

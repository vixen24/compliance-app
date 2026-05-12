class Admin::AccountsController < ApplicationController
  admin_access_only
  before_action :account, only: %i[show update destroy purge]

  layout "admin"

  def show
  end

  def update
    if @account.update(account_params)
      redirect_to admin_account_path(anchor: params[:anchor].presence), notice: "Account updated"
    else
      redirect_to admin_account_path, notice: "Account update failed"
    end
  end

  def destroy
  end

  def purge
    @account.logo.purge
    redirect_to admin_account_path(anchor: params[:anchor].presence), notice: "Logo deleted"
  end

  private

  def account_params
    params.expect(account: [ :mfa_enabled, :password_complexity, :session_timeout, :logo, :primary_color, :secondary_color ])
  end

  def account
    @account ||= Current.account
  end
end

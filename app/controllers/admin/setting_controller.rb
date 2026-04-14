class Admin::SettingController < ApplicationController
  admin_access_only

  layout "admin"

  def show
    @account = Current.user.account
  end

  def update
    if Current.user.account.update(account_params)
      redirect_to admin_setting_path, notice: "Account updated"
    else
      redirect_to admin_setting_path, notice: "Account update failed"
    end
  end

  private

  def account_params
    params.expect(account: [ :mfa_enabled, :password_complexity, :session_timeout ])
  end
end

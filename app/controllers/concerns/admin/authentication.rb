module Admin::Authentication
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
  end

  private

  def authenticate_admin!
    unless Current.user.owner_or_admin?
      redirect_to root_path, alert: "Admin access is required"
    end
  end
end

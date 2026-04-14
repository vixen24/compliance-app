module Admin::Authorization
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def admin_access_only(**options)
      before_action -> { redirect_to main_app.root_path, alert: "Admin access is required" unless Current.user.admin? }, **options
    end
  end
end

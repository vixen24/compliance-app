module Executive::Authorization
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def executive_access_only(**options)
      before_action -> { redirect_to main_app.root_path, alert: "Executive access is required" unless Current.user.executive? }, **options
    end
  end
end

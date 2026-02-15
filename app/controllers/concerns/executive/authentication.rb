module Executive::Authentication
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
  end

  private

  def authorize_executive!
    unless Current.user.executive?
      redirect_to root_path, alert: "Executive access is required"
    end
  end
end

module User::OwnerProtection
  extend ActiveSupport::Concern

  included do
    before_destroy :stop_destroy, if: :owner?
    before_update  :stop_update, if: :role_changed_from_owner?
  end

  private

  def stop_destroy
    return if Current.user&.owner?

    errors.add(:base, "Action is blocked!")
    throw :abort
  end

  def stop_update
    errors.add(:base, "Action is blocked!")
    throw :abort
  end

  def role_changed_from_owner?
    role_was == "owner" && changed?
  end
end

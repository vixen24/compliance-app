module User::Preservable
  extend ActiveSupport::Concern

  included do
    before_destroy :prevent_non_owner_from_deleting_owner
    before_update  :prevent_non_owner_from_modifying_owner
  end

  private

  def prevent_non_owner_from_deleting_owner
    if role == "owner" && !Current.user&.owner?
      errors.add(:base, "Only an owner can delete another owner")
      throw :abort
    end
  end

  def prevent_non_owner_from_modifying_owner
    if role_was == "owner" && !Current.user&.owner? && changed?
      errors.add(:base, "Only an owner can modify another owner")
      throw :abort
    end
  end
end

module User::PasswordHistory
  extend ActiveSupport::Concern

  included do
    validate :password_not_reused, if: -> { password.present? }
  end

  private

  def password_not_reused
    return if password_digest_was.blank?

    if BCrypt::Password.new(password_digest_was) == password
      errors.add(:password, "has already been used")
    end
  end
end

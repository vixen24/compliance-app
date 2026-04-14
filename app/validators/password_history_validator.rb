class PasswordHistoryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if record.password_digest_was.blank?

    if BCrypt::Password.new(record.password_digest_was) == value
      record.errors.add(attribute, :reused, message: options[:message] || "has already been used")
    end
  end
end

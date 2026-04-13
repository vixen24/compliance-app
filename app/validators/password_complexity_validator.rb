class PasswordComplexityValidator < ActiveModel::EachValidator
  MIN_LENGTH = 8
  UPPERCASE_REGEX = /[A-Z]/
  LOWERCASE_REGEX = /[a-z]/
  NUMBER_REGEX    = /\d/
  SPECIAL_REGEX   = /[!@#$%^&*()_\-+\=\[\]{}|\\:;"'<>,.?\/`~]/

  def validate_each(record, attribute, value)
    return if value.blank?
    return unless record.account&.password_complexity?

    if value.length < MIN_LENGTH
      record.errors.add(attribute, "must be at least #{MIN_LENGTH} characters long")
    end

    unless value.match?(UPPERCASE_REGEX)
      record.errors.add(attribute, "must include at least one uppercase letter")
    end

    unless value.match?(LOWERCASE_REGEX)
      record.errors.add(attribute, "must include at least one lowercase letter")
    end

    unless value.match?(NUMBER_REGEX)
      record.errors.add(attribute, "must include at least one number")
    end

    unless value.match?(SPECIAL_REGEX)
      record.errors.add(attribute, "must include at least one special character")
    end
  end
end

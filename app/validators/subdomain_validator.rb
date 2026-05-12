class SubdomainValidator < ActiveModel::EachValidator
  RESERVED = %w[www admin app api mail ftp support blog help].freeze
  FORMAT   = /\A[a-z0-9]+\z/

  def validate_each(record, attribute, value)
    unless value.length.between?(3, 9)
      record.errors.add(attribute, :length, message: "must be between 3 and 9 characters")
      return
    end

    unless value.match?(FORMAT)
      record.errors.add(attribute, :invalid, message: "only allows letters and numbers")
      return
    end

    if RESERVED.include?(value)
      record.errors.add(attribute, :exclusion, message: "is reserved")
    end
  end
end

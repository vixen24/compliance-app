module CompactArrayParams
  extend ActiveSupport::Concern

  private

  # Removes blank values from nested arrays in the params hash.
  # Helps prevent errors in bulk operations like insert_all.
  def compact_array_params(params_hash)
    params_hash.each do |key, value|
      next unless value.is_a?(Array)

      params_hash[key] = value.reject(&:blank?)
    end

    params_hash
  end
end

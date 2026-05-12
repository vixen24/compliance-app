module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, if: :will_save_change_to_name?
  end

  def to_param
    slug
  end

  private

  def generate_slug
    return if name.blank?
    self.slug = name.to_s.parameterize
  end
end

module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :paginate, ->(page, per_page) {
      offset((page - 1) * per_page).limit(per_page)
    }
  end
end

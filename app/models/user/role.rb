module User::Role
  extend ActiveSupport::Concern
  include OwnerProtection

  included do
    enum :role, %i[ owner executive admin member assessor system ].index_by(&:itself),
          default: "member",
          scopes: false

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :non_system, -> { where.not(role: [ :system ]) }
    scope :regular, -> { where.not(role: [ :system, :owner ]) }

    scope :by_role, ->(role) { role.present? ? where(role: role) : all }

    scope :by_team, ->(team) {
      team.presence ? joins(:teams).where(teams: { id: team }) : includes(:teams)
    }

    scope :by_active, ->(active) {
      active.presence ? where(active: ActiveModel::Type::Boolean.new.cast(active)) : all
    }

    def admin?
      super || owner?
    end

    def can_view_assessment?
      role.in?(%w[member assessor])
    end

    def can_create_assessment?
      admin?
    end

    # see SystemUser model for override
    def system?
      false
    end
  end

  class_methods do
    def assignable_roles
      roles.except("owner", "system")
    end
  end
end

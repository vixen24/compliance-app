module Answer::StatePolicy
  extend ActiveSupport::Concern

  included do
    enum :state, %i[ draft submitted approved rejected ].index_by(&:itself), default: :draft
    scope :approved, -> { where(state: :approved) }

    def answerable? = %w[draft rejected].include?(state) && Current.user.member?
    def auditable? = %w[submitted].include?(state) && Current.user.assessor?

    def submittable?(intent) = intent.in? %w[Submit]

    def self.default_answer_state_for(role)
      case role.to_s
      when "assessor"
        "submitted"
      when "member"
        "draft"
      else
        nil
      end
    end
  end
end

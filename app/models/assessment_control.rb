class AssessmentControl < ApplicationRecord
  include Paginatable

  belongs_to :assessment
  belongs_to :control
  # belongs_to :assessment_frameworks
  has_one :answer, dependent: :destroy
  delegate :team, to: :assessment

  # scope :matching, ->(query) do
  #   return none if query.blank?
  #   ts_query = sanitize_sql_array([ "plainto_tsquery('english', ?)", query ])
  #   select("id, question, ts_rank(to_tsvector('english', question), #{ts_query}) AS rank")
  #     .where("to_tsvector('english', question) @@ #{ts_query}")
  #     .order("rank DESC")
  #     .limit(10)
  # end

  scope :matching, ->(query) do
    return all if query.blank?

    if connection.adapter_name == "PostgreSQL"
      ts_query = sanitize_sql_array([ "websearch_to_tsquery('english', ?)", query ])

      select("#{table_name}.*, ts_rank_cd(search_vector, #{ts_query}) AS rank")
        .where("search_vector @@ #{ts_query}")
        .order("rank DESC")
    # .limit(10) # Consider removinf due to .limit in paginate

    else
      # SQLite fallback
      where("question LIKE ?", "%#{query}%")
        .limit(10)
    end
  end

  scope :for_account, ->(account) {
    joins(:assessment) .where(assessments: { account_id: account.id })
  }

  scope :for_assessment, ->(assessment) {
    where(assessment: assessment)
  }

  scope :for_frameworks, ->(frameworks = nil) {
    framework_ids = Array(frameworks).map { |f| f.respond_to?(:id) ? f.id : f }
    framework_ids.any? ? joins(control: :frameworks).where(frameworks: { id: framework_ids }).distinct : all
  }

  scope :for_answer_state, ->(answer_state) {
    return all if answer_state.blank?

    left_joins(:answer).where(
      case answer_state.to_s
      when "draft"
        # For draft: either no answer exists (id: nil) or answer.state is draft
        [ "answers.id IS NULL OR answers.state IN (?)", Array(answer_state) ]
      else
        { answers: { state: Array(answer_state) } }
      end
    )
  }

  scope :for_answer_status, ->(answer_status) {
    return all if answer_status.blank?

    left_joins(:answer).where(
      if answer_status.to_s == "NAS"
        "answers.id IS NULL OR answers.state = 'draft' OR answers.state = 'submitted' OR answers.state = 'rejected'"
      else
        { answers: { state: "approved", status: Array(answer_status) } }
      end
    )
  }

  def answer
    super || NullAnswer.new
  end

  def self.with_assessment_answers(assessment, frameworks = nil, answer_state = nil)
    query = for_assessment(assessment).for_frameworks(frameworks).for_answer_state(answer_state)
    query.includes(:answer)
  end
end

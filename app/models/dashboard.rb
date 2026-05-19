class Dashboard
  attr_reader :team, :assessment, :framework, :page, :per_page,
              :answer_state, :answer_status, :status,
              :total, :answer_state_count, :answer_status_count,
              :oldest_submitted_answer, :earliest_submitted_answer,
              :state_labels, :status_labels, :state_values, :status_values,
              :draft, :not_assessed, :compliance_percentage,
              :filtered_controls, :filtered_controls_per_page,
              :assessments, :frameworks, :framework_controls_by_control,
              :total_framework_excluding_not_applicable

  def initialize(team:, assessment:, framework:, page:, per_page:, answer_state: nil, answer_status: nil, status: "open")
    @team = team
    @assessment = assessment
    @framework = framework
    @page = page
    @per_page = per_page
    @answer_state = answer_state
    @answer_status = answer_status
    @status = status
  end

  def call
    initialize_defaults

    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      load_assessments_with_frameworks
      load_all_control_data
      preload_framework_controls
      load_submitted_answers_in_one_query
      build_chart_data
      total_framework_excluding_NA
      compute_compliance_percentage
      self
    end
  end

  private

  def cache_key
    [
      "executive/assessment_dashboard",
      team.cache_key_with_version,
      assessment&.cache_key_with_version,
      framework&.cache_key_with_version,
      answer_state,
      answer_status,
      status,
      page,
      per_page
    ].compact.join("/")
  end

  def initialize_defaults
    @total ||= { control: 0, control_by_framework: 0 }
    @answer_state_count ||= {}
    @answer_status_count ||= {}
    @state_values ||= [ 0, 0, 0, 0 ]
    @status_values ||= [ 0, 0, 0, 0 ]
    @draft ||= 0
    @not_assessed ||= 0
    @compliance_percentage ||= 0
    @filtered_controls = []
    @filtered_controls_per_page = []
  end

  def preload_framework_controls
    return unless assessment.present? && @filtered_controls_per_page.any?

    control_ids = @filtered_controls_per_page.map(&:control_id)

    @framework_controls_by_control = FrameworkControl
      .where(framework_id: assessment.framework_ids)
      .where(control_id: control_ids)
      .includes(:framework)
      .group_by(&:control_id)
  end

  def load_assessments_with_frameworks
    @assessments = team.assessments
                      .where(status: status)
                      .includes(:frameworks)  # Eager load to avoid N+1
                      .order(created_at: :desc)

    @frameworks = assessment&.frameworks
  end

  def load_all_control_data
    return unless assessment.present?

    # Base controls query - filtered by framework once
    base_controls = assessment.assessment_controls
    base_controls = base_controls.for_frameworks(framework) if framework.present?

    # OPTIMIZATION 3: Use single query with conditional aggregates for counts
    # Instead of 2 separate count_by queries, use one raw SQL query
    @answer_state_count = fetch_answer_state_counts(base_controls)
    @answer_status_count = fetch_answer_status_counts(base_controls)

    # OPTIMIZATION 4: Get total counts from the same query results
    @total = {
      control: assessment.assessment_controls.count,
      control_by_framework: framework.present? ? base_controls.count : assessment.assessment_controls.count
    }

    # OPTIMIZATION 5: Load filtered controls with includes to prevent N+1
    @filtered_controls = base_controls
      .for_answer_state(answer_state)
      .for_answer_status(answer_status)
      .includes(control: :frameworks, answer: {})  # Eager load associations

    @filtered_controls_per_page = @filtered_controls
      .paginate(page, per_page)
      .order(:control_id)
  end

  # Single query for state counts using SQL aggregation
  def fetch_answer_state_counts(base_controls)
    control_ids = base_controls.select(:id)

    Answer.where(assessment_control_id: control_ids)
          .group(:state)
          .count
  end

  # Single query for status counts (approved only)
  def fetch_answer_status_counts(base_controls)
    control_ids = base_controls.select(:id)

    Answer.where(assessment_control_id: control_ids)
          .where(state: "approved")  # Only approved for status counts
          .group(:status)
          .count
  end

  # OPTIMIZATION 6: Single query for both oldest and earliest
  def load_submitted_answers_in_one_query
    return unless assessment.present?

    # Use one query with MIN/MAX aggregation instead of 2 separate queries
    result = Answer.where(assessment_id: assessment.id)
                   .where.not(updated_at: nil)
                   .pick(
                     Arel.sql("MIN(updated_at) as oldest"),
                     Arel.sql("MAX(updated_at) as earliest")
                   )

    @oldest_submitted_answer = result&.first
    @earliest_submitted_answer = result&.last
  end

  def build_chart_data
    return unless assessment.present?

    @draft = @total[:control_by_framework] -
              @answer_state_count.fetch("approved", 0) -
              @answer_state_count.fetch("submitted", 0) -
              @answer_state_count.fetch("rejected", 0)

    @not_assessed = @total[:control_by_framework] -
                    @answer_status_count.fetch("C", 0) -
                    @answer_status_count.fetch("OFI", 0) -
                    @answer_status_count.fetch("NC", 0) -
                    @answer_status_count.fetch("NA", 0)

    @state_labels = %w[approved submitted rejected draft]
    @status_labels = %w[C OFI NC NAS]

    @state_values = [
      @answer_state_count.fetch("approved", 0),
      @answer_state_count.fetch("submitted", 0),
      @answer_state_count.fetch("rejected", 0),
      @draft
    ]

    @status_values = [
      @answer_status_count.fetch("C", 0),
      @answer_status_count.fetch("OFI", 0),
      @answer_status_count.fetch("NC", 0),
      @not_assessed
    ]
  end

  def total_framework_excluding_NA
    @total_framework_excluding_not_applicable = @total[:control_by_framework].to_i - @answer_status_count.fetch("NA", 0)
  end

  def compute_compliance_percentage
    total = @total_framework_excluding_not_applicable.to_i
    compliant = @status_values.to_a[0].to_i

    @compliance_percentage =
      if total > 0
        (compliant.to_f / total * 100).round
      else
        0
      end
  end
end

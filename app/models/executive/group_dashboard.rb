class Executive::GroupDashboard
  attr_reader :account, :framework, :status, :assessment_batch, :labels, :c_values, :ofi_values,
              :nc_values, :nas_values, :c_count, :ofi_count, :nc_count, :nap_count, :app_count,
              :rej_count, :group_controls, :group_compliance, :assessment_coverage, :compliant_extreme

  CompliantExtreme = Struct.new(:most, :least) do
    def initialize(most = nil, least = nil)
      super(most || [], least || [])
    end
  end

  BASE_COUNTS = { C: 0, OFI: 0, NC: 0, NA: 0, approved: 0, rejected: 0 }.freeze

  def initialize(account:, status:, framework: nil, assessment_batch:)
    @account   = account
    @status = status
    @framework = framework
    @assessment_batch = assessment_batch
    @labels        = []
    @c_values      = []
    @ofi_values    = []
    @nc_values     = []
    @nas_values    = []
    @c_count       = []
    @ofi_count     = []
    @nc_count      = []
    @nap_count     = []
    @app_count     = []
    @rej_count     = []
    @group_controls = []
    @group_compliance = 0
    @assessment_coverage = 0
    @compliant_extreme = CompliantExtreme.new
  end

  def call
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      load_base_data
      load_control_counts
      load_answer_counts
      compute_percentages
      compute_compliant_extreme
      self
    end
  end

  private

  def cache_key
    [
      "executive/group_dashboard",
      account&.cache_key_with_version,
      assessment_batch&.cache_key_with_version,
      framework&.cache_key_with_version,
      status
    ].compact.join("/")
  end

  def load_base_data
    return unless @assessment_batch.present?

    @teams = @assessment_batch
              .assessments
              .joins(:team)
              .distinct
              .order("teams.name")
              .pluck("teams.id", "teams.name")

    @assessment_ids = @assessment_batch
                        .assessments
                        .pluck(:id)
  end

  def load_control_counts
    return unless @assessment_batch.present?

    scope = AssessmentControl
              .joins(:assessment)
              .where(assessments: { id: @assessment_ids })

    if @framework.present?
      scope = scope
                .joins(control: :frameworks)
                .where(frameworks: { id: @framework.id })
    end

    @controls_count_by_team = scope.group("assessments.team_id").count
  end

  def load_answer_counts
    return unless @assessment_batch.present?

    # Load answers counts grouped by status and state per team
    answers_query = Answer
                    .joins(assessment_control: :assessment)
                    .where(assessment_controls: { assessment_id: @assessment_ids })
                    .where(state: "approved")

    if framework.present?
      answers_query = answers_query
                      .joins(assessment_control: { control: :frameworks })
                      .where(frameworks: { id: @framework.id })
    end

    answers_counts = answers_query.group("assessments.team_id", :status, :state).count

    @answers_counts_by_team = {}
    answers_counts.each do |(team_id, status, state), count|
      @answers_counts_by_team[team_id] ||= { C: 0, OFI: 0, NC: 0, NA: 0, approved: 0, rejected: 0 }
      @answers_counts_by_team[team_id][status.to_sym] += count if status
      @answers_counts_by_team[team_id][state.to_sym]  += count if state
    end
  end

  def compute_percentages
    return unless @assessment_batch.present?

    @teams.each do |team_id, team_name|
      team_counts = @answers_counts_by_team[team_id] || { C: 0, OFI: 0, NC: 0, NA: 0, approved: 0, rejected: 0 }
      controls_count = @controls_count_by_team[team_id] || 0
      denominator = [ (controls_count - team_counts[:NA]), 1 ].max.to_f

      @labels        << team_name
      @c_values      << ((team_counts[:C].to_f   / denominator) * 100).round
      @ofi_values    << ((team_counts[:OFI].to_f / denominator) * 100).round
      @nc_values     << ((team_counts[:NC].to_f  / denominator) * 100).round
      @nas_values    << (((controls_count - team_counts.values_at(:C, :OFI, :NC, :NA).sum) / denominator) * 100).round

      @c_count   << team_counts[:C]
      @ofi_count << team_counts[:OFI]
      @nc_count  << team_counts[:NC]
      @nap_count << team_counts[:NA]
      @app_count << team_counts[:approved]
      @rej_count << team_counts[:rejected]
      @group_controls << controls_count
    end

    total_controls = @group_controls.sum.to_f
    denominator = total_controls - @nap_count.sum.to_f

    @group_compliance = safe_percentage(@c_count.sum, denominator)
    @assessment_coverage = safe_percentage(@app_count.sum + @rej_count.sum, total_controls)
  end

  def safe_percentage(numerator, denominator)
    return 0 if denominator.to_f <= 0
    (numerator.to_f / denominator) * 100
  end

  def compute_compliant_extreme
    return unless @assessment_batch.present?
    return if c_values.all?(&:zero?)

    pairs = labels.zip(c_values)

    max = pairs.max_by(&:last).last
    min = pairs.min_by(&:last).last

    most  = pairs.select { |_, v| v == max }.map(&:first)
    least = pairs.select { |_, v| v == min }.map(&:first)

    @compliant_extreme = CompliantExtreme.new(most, least)
  end
end

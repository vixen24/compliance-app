class Executive::GroupDashboard
  attr_reader :account, :framework, :teams, :labels, :c_values, :ofi_values, :nc_values, :nas_values, :c_count, :ofi_count,
      :nc_count, :nap_count, :app_count, :rej_count, :group_controls, :group_compliance, :assessment_coverage, :compliant_extreme

  CompliantExtreme = Struct.new(:most, :least)

  def initialize(account:, framework: nil)
    @account   = account
    @framework = framework
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
  end

  def call
    load_teams
    load_counts
    compute_percentages
    compute_compliant_extreme
    self
  end



  private

  def compute_compliant_extreme
    compliant_count_sql = "SUM(CASE WHEN answers.status = 'C' THEN 1 ELSE 0 END)"
    base = Team.where(account_id: account.id).left_joins(assessments: :answers).group("teams.id")

    min_count = base.pluck(Arel.sql(compliant_count_sql)).min
    max_count = base.pluck(Arel.sql(compliant_count_sql)).max

    least = base.having("#{compliant_count_sql} = ?", min_count) .pluck(:name)
    most = base.having("#{compliant_count_sql} = ?", max_count) .pluck(:name)

    @compliant_extreme = CompliantExtreme.new(most, least)
  end

  def load_teams
    @teams = Team.where(account_id: account.id).order(:name).pluck(:id, :name)
  end

  def load_counts
    team_ids = @teams.map(&:first)
    assessments = Assessment.where(team_id: team_ids, status: "open").pluck(:id, :team_id)

    # Load controls count per team (filtered by framework if present)
    controls_query = AssessmentControl .joins(:assessment) .where(assessments: { id: assessments.map(&:first) })
    controls_query = controls_query.joins(control: :frameworks)
                                   .where(frameworks: { id: framework.id }) if framework.present?
    @controls_count_by_team = controls_query.group("assessments.team_id").count

    # Load answers counts grouped by status and state per team
    answers_query = Answer.joins(assessment_control: :assessment).where(assessment_controls: { assessment_id: assessments.map(&:first) })
                          .where(state: "approved")

    if framework.present?
      answers_query = answers_query.joins(assessment_control: { control: :frameworks }).where(frameworks: { id: framework.id })
    end

    answers_counts = answers_query.group("assessments.team_id", :status, :state).count

    @answers_counts_by_team = Hash.new { |h, k| h[k] = { C: 0, OFI: 0, NC: 0, NA: 0, approved: 0, rejected: 0 } }
    answers_counts.each do |(team_id, status, state), count|
      @answers_counts_by_team[team_id][status.to_sym] += count if status
      @answers_counts_by_team[team_id][state.to_sym]  += count if state
    end
  end

  def compute_percentages
    @teams.each do |team_id, team_name|
      team_counts = @answers_counts_by_team[team_id]
      controls_count = @controls_count_by_team[team_id] || 0
      denominator = [ (controls_count - team_counts[:NA]), 1 ].max.to_f

      # Chart data
      @labels        << team_name
      @c_values      << ((team_counts[:C].to_f   / denominator) * 100).round
      @ofi_values    << ((team_counts[:OFI].to_f / denominator) * 100).round
      @nc_values     << ((team_counts[:NC].to_f  / denominator) * 100).round
      @nas_values    << (((controls_count - team_counts.values_at(:C, :OFI, :NC, :NA).sum) / denominator) * 100).round

      # Raw counts for tables/other metrics
      @c_count   << team_counts[:C]
      @ofi_count << team_counts[:OFI]
      @nc_count  << team_counts[:NC]
      @nap_count << team_counts[:NA]
      @app_count << team_counts[:approved]
      @rej_count << team_counts[:rejected]
      @group_controls << controls_count
    end

    total_controls = @group_controls.sum.to_f
    @group_compliance = (@c_count.sum / (total_controls - @nap_count.sum) * 100) rescue 0
    @assessment_coverage = (((@app_count.sum + @rej_count.sum) / total_controls) * 100) rescue 0
  end
end

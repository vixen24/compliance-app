class Executive::SubsidiaryDashboard
  attr_reader :team, :framework, :compliant_extreme, :metrics

  Metrics = Struct.new(:controls, :controls_by_framework,)

  def initialize(team:, assessment:, framework: nil)
    @team   = team
    @framework = framework
    @assessment = assessment
    @metrics  = []
  end

  def call
    load_teams
    load_counts
    compute_percentages
    compute_compliant_extreme
    self
  end

  private
  def calculate_metrics
    @metrics = Metrics.new()
  end
end

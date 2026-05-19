class Executive::SubsidiaryDashboardController < ApplicationController
  executive_access_only

  before_action :set_team
  before_action :set_assessment_status, only: %i[show]
  before_action :set_assessments, only: %i[show]
  before_action :set_assessment, only: %i[show]
  before_action :set_framework, only: %i[show]
  before_action :set_pagination, only: %i[show]
  before_action :set_answer_state, only: %i[show]
  before_action :set_answer_status, only: %i[show]

  def show
    @metrics = Executive::SubsidiaryDashboard.new(
      team: @team,
      assessment: @assessment,
      framework: @framework,
      page: @page,
      per_page: @per_page,
      answer_state: @answer_state,
      answer_status: @answer_status,
      status: @status
    ).call
    puts "--------------------------------"
    puts "yay"
    puts @metrics.filtered_controls_per_page.inspect
  end

  private

  DEFAULT_STATUS = "open"
  DEFAULT_PAGE      = 1.freeze
  DEFAULT_PER_PAGE  = 10.freeze

  def set_pagination
    @page = params[:page].to_i.clamp(DEFAULT_PAGE, Float::INFINITY) || DEFAULT_PAGE
    @per_page = (params[:per_page] || DEFAULT_PER_PAGE).to_i
  end

  def set_team
    teams = Current.account.teams
    @team = params[:team].present? ? teams.where_slug_or_name(params[:team]).first : teams.first
  end

  def set_assessment_status
    @status = params[:status] || DEFAULT_STATUS
  end

  def set_assessments
    @assessments = @team.assessments.where(status: @status).order(created_at: :desc)
  end

  def set_assessment
    scope = @assessments.includes(assessment_controls: :answer)
    @assessment = scope.find_by(id: params[:id]) || scope.first
  end

  def set_framework
    @framework = @assessment&.frameworks&.find(params[:framework]) if params[:framework].present?
  end

  def set_frameworks
    @frameworks = @assessment&.frameworks
  end

  def set_answer_state
    @answer_state = params[:answer_state] if params[:answer_state].present?
  end

  def set_answer_status
    @answer_status = params[:answer_status] if params[:answer_status].present?
  end
end

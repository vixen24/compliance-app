class DashboardController < ApplicationController
  before_action :set_current_team
  before_action :set_team
  before_action :set_assessment_status, only: %i[show]
  before_action :set_assessments, only: %i[show]
  before_action :set_assessment, only: %i[show]
  before_action :set_framework, only: %i[show]
  before_action :set_frameworks, only: %i[show]
  before_action :set_pagination, only: %i[show]
  before_action :set_answer_state, only: %i[show]
  before_action :set_answer_status, only: %i[show]
  before_action :set_filtered_controls, only: %i[show]
  before_action :set_filtered_controls_per_page, only: %i[show]


  def show
     # @dashboard = Executive::SubsidiaryDashboard.new(team: @team, assessment: @assessment, framework: @framework, page: @page, per_page: @per_page).call

     @total = Hash.new(0)

    return unless @assessment.present?

    @answer_state_count = Answer.count_by(:state, assessment: @assessment, framework: @framework).count
    @answer_status_count = Answer.count_by(:status, assessment: @assessment, framework: @framework, only_approved: true).count


    @total = {
      control: @assessment.assessment_controls.count,
      control_by_framework: @assessment.assessment_controls.for_frameworks(@framework).count
    }

    @oldest_submitted_answer = Answer.oldest_submitted_for_assessment(@assessment.id)
    @earliest_submitted_answer = Answer.earliest_submitted_for_assessment(@assessment.id)

    build_chart_data

    @compliance_percentage = @total[:control_by_framework]  > 0 ? (@status_values[0].to_f / @total[:control_by_framework] * 100).round : 0
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
    @team = Current.team
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

  def set_filtered_controls
    controls = @assessment&.assessment_controls || AssessmentControl.none

    @filtered_controls = controls .for_frameworks(@framework).for_answer_state(@answer_state).for_answer_status(@answer_status)
  end

  def set_filtered_controls_per_page
    @filtered_controls_per_page = @filtered_controls&.paginate(@page, @per_page)&.order(:control_id)
  end

  def set_answer_state
    @answer_state = params[:answer_state] if params[:answer_state].present?
  end

  def set_answer_status
    @answer_status = params[:answer_status] if params[:answer_status].present?
  end

  def build_chart_data
    # NA (aka Out-of-scope) is subtrated from all attributes
    @draft = @total[:control_by_framework] - @answer_state_count.fetch("approved", 0) - @answer_state_count.fetch("submitted", 0) - @answer_state_count.fetch("rejected", 0)
    @not_assessed = @total[:control_by_framework] - @answer_status_count.fetch("C", 0) - @answer_status_count.fetch("OFI", 0) - @answer_status_count.fetch("NC", 0) - @answer_status_count.fetch("NA", 0)



    @state_labels = [
      "approved",
      "submitted",
      "rejected",
      "draft"
    ]

    @status_labels = [
      "C",
      "OFI",
      "NC",
      "NAS"
    ]

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
end

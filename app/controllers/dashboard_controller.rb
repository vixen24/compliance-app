class DashboardController < ApplicationController
  before_action :set_current_team
  before_action :set_assessment_status, only: %i[show]
  before_action :set_assessments, only: %i[show]
  before_action :set_assessment, only: %i[show]
  before_action :set_framework, only: %i[show]
  before_action :set_frameworks, only: %i[show]
  # before_action :set_frameworks_ids, only: %i[show]
  def show
    @total = { control: 0, control_by_framework: 0, compliant: 0, compliant_by_framework: 0 }

    return unless @assessment.present?
    @answer_state_count = Answer.count_by(:state, assessment: @assessment, framework: @framework).count
    @answer_status_count = Answer.count_by(:status, assessment: @assessment, framework: @framework, only_approved: true).count
    build_chart_data
  end

  private

  DEFAULT_STATUS = "open"

  def set_assessment_status
    @status = params[:status] || DEFAULT_STATUS
  end

  def set_assessments
    @assessments = Current.team.assessments.where(status: @status).order(created_at: :desc)
  end

  def set_assessment
    @assessment = @assessments.find_by(id: params[:id]) || @assessments.first
  end

  def set_framework
    @framework = @assessment&.frameworks&.find(params[:framework]) if params[:framework].present?
  end

  def set_frameworks
    @frameworks = @assessment&.frameworks
  end

  # def set_frameworks_ids
  #   @framework_ids = @framework&.id || @frameworks&.map(&:id)
  # end

  def build_chart_data
    @total = {
      control: @assessment.assessment_controls.count,
      control_by_framework: @assessment.assessment_controls.for_frameworks(@framework).count
    }

    # NA (aka Out-of-scope) is subtrated from all attributes
    @draft = @total[:control_by_framework] - @answer_state_count.fetch("approved", 0) - @answer_state_count.fetch("submitted", 0) - @answer_state_count.fetch("rejected", 0)
    @not_assessed = @total[:control_by_framework] - @answer_status_count.fetch("C", 0) - @answer_status_count.fetch("OFI", 0) - @answer_status_count.fetch("NC", 0) - @answer_status_count.fetch("NA", 0)



    @state_labels = [
      "Approved",
      "Pending Approval",
      "Rejected",
      "Draft"
    ]

    @status_labels = [
      "Compliant",
      "Opportunity for Improvement",
      "Not Compliant",
      "Not Assessed"
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

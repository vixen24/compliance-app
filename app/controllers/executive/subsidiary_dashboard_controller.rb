class Executive::SubsidiaryDashboardController < ApplicationController
  include Executive::Authentication
  before_action :authorize_executive!

  before_action :set_team, only: %i[show]
  before_action :set_assessment_status, only: %i[show]
  before_action :set_assessments, only: %i[show]
  before_action :set_assessment, only: %i[show]
  before_action :set_framework, only: %i[show]
  before_action :set_frameworks, only: %i[show]

  DEFAULT_STATUS = "open"

  def show
     @total = { control: 0, control_by_framework: 0, compliant: 0, compliant_by_framework: 0 }

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

  def set_team
    @team = params[:team].present? ? (Team.find_by(id: params[:team]) || Team.find_by(name: params[:team])) : Current.user.account.teams.first
  end

  def set_assessment_status
    @status = params[:status] || DEFAULT_STATUS
  end

  def set_assessments
    @assessments = @team.assessments.where(status: @status).order(created_at: :desc)
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

  def build_chart_data
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

  def set_group
    @answer_state_count = Answer.count_by_account(:state, account: Current.user.account).count
    @answer_status_count = Answer.count_by_account(:status, account: Current.user.account, only_approved: true).count
  end
end

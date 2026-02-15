class AssessmentsController < ApplicationController
  before_action :set_current_team
  before_action :authenticate_admin!, only: %i[new edit create update destroy] # blocker: prevents user from creating or modifying assessments
  before_action :ensure_viewable!
  before_action :set_pagination, only: %i[show]
  before_action :set_framework, only: %i[show]
  before_action :set_answer_state, only: %i[show]
  before_action :set_assessment, only: %i[show]
  before_action :set_assessment_frameworks, only: %i[show]
  before_action :set_frameworks, only: %i[new create]
  before_action :set_assessment_controls, only: %i[show]

  DEFAULT_PAGE      = 1.freeze
  DEFAULT_PER_PAGE  = 20.freeze
  def index
    @assessments = Current.team.assessments.includes(:frameworks).order(created_at: :desc)
  end

  def show
    @controls = @assessment_controls.order(control_id: :asc).paginate(@page, @per_page)
    @control = params[:control].present? ? @controls.find { |c| c.id == params[:control].to_i } : @controls.first
  end

  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Current.team.assessments.new(assessment_params.merge(user: Current.user))

    if @assessment.save
      redirect_to admin_assessments_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_pagination
    @page = params[:page].to_i.clamp(1, Float::INFINITY) || 1
    @per_page = (params[:per_page] || DEFAULT_PER_PAGE).to_i
  end

  def set_framework
    @framework = Framework.find(params[:framework]) if params[:framework].present?
  end

  def set_answer_state
    @answer_state = params.key?(:answer_state) ? params[:answer_state] : nil
  end

  def set_assessment
    @assessment = Current.team.assessments.find(params[:id])
  end

  # Loads controls for a given assessment, based on the framework(s) present
  def set_assessment_controls
    frameworks = @framework || @frameworks
    @assessment_controls = AssessmentControl.with_assessment_answers(@assessment, frameworks, @answer_state)
  end

  # Load all frameworks for a given assessment
  def set_assessment_frameworks
    @frameworks = @assessment.frameworks
  end

  # Load all frameworks available
  def set_frameworks
    @frameworks = Framework.all
  end

  def assessment_params
    params.require(:assessment).permit(:name, :due_date, framework_ids: []).tap do |params|
      params[:framework_ids] = Array(params[:framework_ids]).reject(&:blank?).map(&:to_i)
    end
  end

  def ensure_viewable!
    return if Current.user.can_view_assessment?
    redirect_back fallback_location: admin_assessments_path, alert: "Action not allowed"
  end
end

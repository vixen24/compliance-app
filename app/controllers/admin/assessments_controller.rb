class Admin::AssessmentsController < ApplicationController
  admin_access_only

  layout "admin"

  before_action :set_assessment_batch, only: %i[update destroy]
  before_action :set_teams, only: %i[new create]
  before_action :set_frameworks, only: %i[new create]

  def show
  end

  def index
    @assessment_batches = Current.user.account.assessment_batches.includes(assessments: [ team: [], frameworks: [], user: [] ]).order(created_at: :desc)
  end

  def new
    @assessment_batch = AssessmentBatch.new
  end

  def create
    @assessment_batch = AssessmentBatch.new(batch_assessment_params)

    if @assessment_batch.save_batch
      respond_to do |format|
        format.html { redirect_to admin_assessments_path, notice: "Assessments created" }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, admin_assessments_path) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @assessment_batch.update_batch(params[:status])
      redirect_to admin_assessments_path, notice: "Assessments updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Uses background job
  def destroy
    if @assessment_batch.destroy_batch
      redirect_to admin_assessments_path, notice: "Assessments is deleting..."
    else
      redirect_to admin_assessments_path, alert: "Failed to delete assessments"
    end
  end

  private

  def set_teams
    @teams = Current.user.account.teams
  end

  def set_frameworks
    @frameworks = Framework.all
  end

  def set_assessment_batch
    @assessment_batch = Current.user.account.assessment_batches.find_by(id: params[:id])
  end

  def batch_assessment_params
    params.require(:assessment_batch).permit(:name, :status, team_ids: [], framework_ids: [])
          .tap { |p| p[:team_ids]&.reject!(&:blank?)
                     p[:framework_ids]&.reject!(&:blank?)
                }
          .merge(user_id: Current.user.id, account_id: Current.user.account.id)
  end
end

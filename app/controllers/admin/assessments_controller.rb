class Admin::AssessmentsController < ApplicationController
  include CompactArrayParams

  admin_access_only

  before_action :set_assessment_batch, only: %i[update destroy]
  before_action :set_teams, only: %i[new create]
  before_action :set_frameworks, only: %i[new create]

  layout "admin"

  def show
  end

  def index
    @assessment_batches = Current.account.assessment_batches.available.includes(assessments: [ team: [], frameworks: [], user: [] ]).order(created_at: :desc)
  end

  def new
    @assessment_batch = AssessmentBatch.new(year: Date.current.year)
  end

  def create
    @assessment_batch = Current.account.assessment_batches.new(
      batch_assessment_params.merge(user: Current.user)
    )

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

  def destroy
    if @assessment_batch.destroy_batch
      redirect_to admin_assessments_path, notice: "Moved to Trash. To be deleted in 24 hours"
    else
      redirect_to admin_assessments_path, alert: "Failed to delete assessments"
    end
  end

  private

  def set_teams
    @teams = Current.account.teams
  end

  def set_frameworks
    @frameworks = Framework.all
  end

  def set_assessment_batch
    @assessment_batch = Current.account.assessment_batches.find_by(id: params[:id])
  end

  def batch_assessment_params
    compact_array_params(
      params.expect(assessment_batch: [ :name, :status, :year, team_ids: [], framework_ids: [] ])
    )
  end
end

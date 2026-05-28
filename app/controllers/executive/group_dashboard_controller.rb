class Executive::GroupDashboardController < ApplicationController
  executive_access_only

  before_action :set_account, only: %i[show]
  before_action :set_assessment_status, only: %i[show]
  before_action :set_assessment_batches, only: %i[show]
  before_action :set_assessment_batch, only: %i[show]
  before_action :set_framework, only: [ :show ]
  before_action :set_frameworks, only: [ :show ]

  def show
    @metrics = Executive::GroupDashboard.new(
      account: @account,
      status: @status,
      framework: @framework,
      assessment_batch: @assessment_batch
    ).call
  end

  private

  DEFAULT_STATUS = "open"

  def set_account
    @account = Current.account
  end

  def set_assessment_status
    @status = params[:status] || DEFAULT_STATUS
  end

  def set_assessment_batches
    @assessment_batches = @account.assessment_batches.where(status: @status).order(created_at: :desc)
  end

  def set_assessment_batch
    scoped = @assessment_batches.includes(:assessments)
    @assessment_batch = scoped.find_by(id: params[:id]) || scoped.first
  end

  def set_framework
    @framework = @assessment_batch&.assessments&.first&.frameworks&.find(params[:framework]) if params[:framework].present?
  end

  def set_frameworks
    @frameworks = Rails.cache.fetch([ "frameworks", Framework.maximum(:updated_at) ]) do
      Framework.order(:name).to_a
    end
  end
end

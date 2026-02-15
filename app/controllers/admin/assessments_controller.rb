class Admin::AssessmentsController < ApplicationController
  include Admin::Authentication

  before_action :authenticate_admin!
  before_action :set_assessment_params, only: %i[create]
  before_action :set_teams, only: %i[new create]

  layout "admin"

  def show
  end

  def index
    @assessments = Current.user.account.assessments.includes(team: [], frameworks: [], user: []).order(created_at: :desc)
  end

  def new
    @assessment = Assessment.new
    @errors = {}
  end

  def create
    if validate_assessment_params
      result = Assessment.bulk_create_with_controls(@name, @team_ids, @framework_ids, Current.user)

      if result[:errors].any?
        @errors = result[:errors]
        render :new, status: :unprocessable_entity
      else
        redirect_to admin_assessments_path, notice: "Initializing assessments..."
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
  end

  def destroy
  end

  private

  def set_teams
    @teams = Current.user.account.teams
  end

  def set_assessment_params
    @team_ids = params[:team_ids]
    @framework_ids = params[:framework_ids]
    @name = params[:name]
  end

  def validate_assessment_params
    if @team_ids.present? && @framework_ids.present? && @name.present?
      true
    else
      flash.now[:alert] =
        if @team_ids.blank?
          "No teams selected."
        elsif @framework_ids.blank?
          "No frameworks selected."
        else
          "Name cannot be blank."
        end
      false
    end
  end
end

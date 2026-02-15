class ControlsController < ApplicationController
  before_action :set_current_team
  before_action :set_pagination, only: %i[index]
  before_action :set_framework, only: %i[index]
  before_action :set_framework_controls, only: %i[index]

  DEFAULT_PAGE      = 1
  DEFAULT_PER_PAGE  = 1

  def show
  end
  def index
    @controls = @framework_controls.paginate(@page, @per_page)
    @controls_count = @framework_controls.size
    @frameworks = Framework.all
  end

  private

  def set_framework_controls
    @framework_controls = Control.for_framework(@framework)
  end

  def set_framework
    @framework = Framework.find(params[:framework]) if params[:framework].present?
  end

  def set_pagination
    @page = params.fetch(:page, DEFAULT_PAGE).to_i
    @per_page = params.fetch(:per_page, DEFAULT_PER_PAGE).to_i
  end
end

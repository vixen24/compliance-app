class Executive::GroupDashboardController < ApplicationController
  executive_access_only
  before_action :set_framework, only: [ :show ]
  before_action :set_frameworks, only: [ :show ]

  def show
    @metrics = Executive::GroupDashboard.new(account: Current.user.account, framework: @framework).call
  end

  private

  def set_framework
    @framework = Framework.find_by(id: params[:framework]) if params[:framework].present?
  end

  def set_frameworks
    @frameworks = Rails.cache.fetch([ "frameworks", Framework.maximum(:updated_at) ]) do
      Framework.order(:name).to_a
    end
  end
end

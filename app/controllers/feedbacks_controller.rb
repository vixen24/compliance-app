class FeedbacksController < ApplicationController
  before_action :set_current_team
  before_action :set_intent, only: %i[create]

  def  index
  end

  def new
    @feedback = Feedback.new
  end


  def create
    @feedback = feedback_params.assign_arributes()
  end

  private

  def set_intent
    @intent = params.fetch(:intent)
  end

  def feedback_params
  end
end

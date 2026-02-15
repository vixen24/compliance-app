class Answers::ReviewsController < ApplicationController
  before_action :set_current_team
  before_action :set_answer

  def accept
    @answer.accept!
    redirect_back fallback_location: team_assessments_url, notice: "Answer accepted"
  end

  def reject
    @answer.reject!
    redirect_back fallback_location: team_assessments_url, notice: "Answer rejected"
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end
end

class AnswersController < ApplicationController
  before_action :set_current_team
  before_action :set_answer, only: %i[update]
  before_action :upsert_answer, only: %i[create]
  before_action :ensure_auditable!, only: %i[update]
  before_action :ensure_answerable!, only: %i[create]
  before_action :set_intent, only: %i[create update]

  def new
  end

  def create
    if @answer.submittable?(@intent) && @answer.submitted!
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: team_assessments_url, notice: "Submitted for review" }
      end
    elsif @answer.save
      head :ok
    else
      redirect_back fallback_location: team_assessments_url, alert: answer.errors.full_messages.to_sentence
    end
  end

  def update
    if @intent.in?(%w[Approve]) && @answer.approved!
      @notice = "Answer accepted"
    elsif @intent.in?(%w[Reject]) && @answer.rejected!
      @notice = "Answer rejected"
    else
      @notice = answer.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: team_assessments_url, notice: @notice }
    end
  end

  private

  def set_intent
    @intent = params[:intent]&.presence
  end

  def upsert_answer
    @answer = Answer.upsert_from(answer_params.merge(user_id: Current.user.id))
  end

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def ensure_answerable!
    return if @answer.answerable?
    redirect_back fallback_location: team_assessments_url, alert: "This answer cannot be edited."
  end

  def ensure_auditable!
    return if @answer.auditable?
    redirect_back fallback_location: team_assessments_url, alert: "This answer cannot be edited."
  end

  def answer_params
    params.require(:answer).permit(:assessment_control_id, :user_id, :assessment_id, :status, :comment, :url)
  end
end

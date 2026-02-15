class NullAnswer
  def state = "draft"
  def status = nil
  def comment = nil
  def url = nil

  def draft? = true
  def submitted? = false
  def approved? = false
  def rejected? = false

  def answerable? = %w[draft rejected].include?(state) && Current.user.member?
  def auditable? = %w[submitted].include?(state) && Current.user.assessor?

  def persisted? = false
  def id = nil
end

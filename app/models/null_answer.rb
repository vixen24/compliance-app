class NullAnswer
  def state = "draft"
  def status = "NAS"
  def comment = nil
  def url = nil

  def draft? = true
  def submitted? = false
  def approved? = false
  def rejected? = false

  def answerable? = %w[draft rejected].include?(state) && Current.user.member?
  def auditable? = %w[submitted].include?(state) && Current.user.assessor?

  STATUS_LABELS = { "NAS"  => "not assessed" }.freeze
  STATE_LABELS = {
    "draft"   => "draft",
    "approved"  => "approved",
    "submitted" => "pending approval",
    "rejected"  => "rejected"
  }.freeze

  def status_label = STATUS_LABELS[status]
  def state_label  = STATE_LABELS[state]

  def persisted? = false
  def id = nil
end

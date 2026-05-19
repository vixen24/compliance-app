module AssessmentBatchesHelper
  def assessment_batch_status_options
    AssessmentBatch.statuses.keys.map { |status| [ status.humanize, status ] }
  end
end

class AssessmentBatchCleanupJob < ApplicationJob
  queue_as :high_priority

  def perform(batch)
    batch.delete_associated_records
  end
end

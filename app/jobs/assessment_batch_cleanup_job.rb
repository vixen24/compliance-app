class AssessmentBatchCleanupJob < ApplicationJob
  queue_as :high_priority

  BATCH_SIZE = 1000

  def perform(batch)
    batch.delete_assessments(BATCH_SIZE)
    batch.delete_batch
  end
end

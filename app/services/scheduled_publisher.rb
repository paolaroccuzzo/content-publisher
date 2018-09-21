class ScheduledPublisher
  def self.run
    scheduled = Document.where("scheduled_at < ?", Time.now)
    scheduled.each do |document|
      Document.transaction do
        document.update!(scheduled_at: nil)
        DocumentPublishingService.new.publish(document, "reviewed")
      end
    end
  end
end

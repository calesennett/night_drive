module MessageScheduler
  class << self
    def schedule_for(duration, sender_id)
      (60..duration).step(60).each do |interval|
        MessageSenderJob.set(wait: interval.seconds).perform_later(sender_id)
      end
    end

    private
  end
end

module DrivePing
  include Facebook::Messenger

  Bot.on :message do |message|
    @message = message

    intent, @duration = WitClient.parse(@message.text)

    case intent
    when 'Start_drive_session'
      if @duration
        @message.reply(text: "Starting your drive for #{ ActionController::Base.helpers.distance_of_time_in_words(@duration) }")
        schedule_messages
      else
        @message.reply(text: "For how long?")
      end
    when 'Stop_drive_session'
      cancel_messages
      @message.reply(text: "I won't ping you any longer. Thanks for using DrivePing!")
    when 'Unknown'
      @message.reply(text: "I'm not sure what you mean.")
    end
  end

  class << self
    private
      def schedule_messages
        MessageScheduler.schedule_for(@duration, @message.sender["id"])
      end

      def cancel_messages
        queue = Sidekiq::ScheduledSet.new
        jobs = queue.scan("MessageSenderJob")
        jobs.each do |job|
          job.delete if job.args.first["arguments"].include?(@message.sender["id"])
        end
      end
  end
end

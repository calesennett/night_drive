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
        @message.reply(text: 'For how long?')
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
        MessageScheduler.schedule_for(@duration, @message.sender['id'])
      end

      def cancel_messages
        SolidQueue::Job
          .where(
            class_name: 'MessageSenderJob',
            scheduled_at: DateTime.now..
          )
          .where("arguments ->> 'arguments' = ?", [@message.sender['id']].to_json)
          .destroy_all
      end
  end
end

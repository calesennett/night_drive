class MessageSenderJob < ApplicationJob
  queue_as :default

  include Facebook::Messenger

  def perform(sender_id)
    Bot.deliver({
      recipient: {
        id: sender_id
      },
      message: {
        text: "Ping!"
      }
    }, access_token: Rails.application.credentials.facebook[:access_token])
  end
end

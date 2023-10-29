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
    }, page_id: Rails.application.credentials.facebook[:page_id])
  end
end

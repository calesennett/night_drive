unless Rails.env.production?
  bot_files = Dir[Rails.root.join('app', 'bot', '**', '*.rb')]
  bot_reloader = ActiveSupport::FileUpdateChecker.new(bot_files) do
    bot_files.each{ |file| require_dependency file }
  end

  ActiveSupport::Reloader.to_prepare do
    bot_reloader.execute_if_updated
  end

  bot_files.each { |file| require_dependency file }
end

ENV['ACCESS_TOKEN'] ||= Rails.application.credentials.facebook[:access_token]
ENV['VERIFY_TOKEN'] ||= Rails.application.credentials.facebook[:verify_token]
ENV['APP_SECRET'] ||= Rails.application.credentials.facebook[:app_secret]

Facebook::Messenger::Subscriptions.subscribe(
  access_token: Rails.application.credentials.facebook[:access_token],
  subscribed_fields: %w[messages]
)

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Facebook::Messenger::Server, at: 'bot'
  mount Sidekiq::Web => '/sidekiq'
end

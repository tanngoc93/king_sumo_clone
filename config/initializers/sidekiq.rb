require 'sidekiq'
require 'sidekiq/web'

SIDEKIQ_URL = if ENV["REDIS_URL"]
                ENV["REDIS_URL"]
              else
                "redis://127.0.0.1:6379"
              end

Sidekiq.configure_server do |config|
  config.redis = { url: "#{SIDEKIQ_URL}/0" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{SIDEKIQ_URL}/0" }
end
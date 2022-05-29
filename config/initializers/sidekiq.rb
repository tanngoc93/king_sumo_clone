require 'sidekiq'
require 'sidekiq/web'

REDIS_URL = ENV["REDIS_URL"] || "redis://127.0.0.1:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: "#{ REDIS_URL }/0" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{ REDIS_URL }/0" }
end

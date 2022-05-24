class HardJob
  include Sidekiq::Job

  def perform
    Rails.logger.debug("Run Hard Job")
  end
end

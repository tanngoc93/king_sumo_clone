require "csv"

class Campaign < ApplicationRecord
  paginates_per 100

  has_many :images, dependent: :destroy
  has_many :contestants, dependent: :destroy
  has_many :share_actions, dependent: :destroy
  has_many :bonus_entries, dependent: :destroy

  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :user

  accepts_nested_attributes_for :share_actions, allow_destroy: true
  accepts_nested_attributes_for :bonus_entries, allow_destroy: true

  validates :title, presence: true

  before_create :set_times_and_status, :set_url
  before_update :set_times_and_status

  after_create :set_campaign_status_job
  after_update :set_campaign_status_job

  enum status: %i[ upcoming running expired archived ]
  enum currency_unit: %i[ usd euro ]

  def to_csv
    attributes = %w{id full_name email registered_ip confirmed_ip created_at confirmed total_points total_referrals}

    headers = attributes.map { |attr| attr.titleize }

    CSV.generate(headers: true) do |csv|
      csv << headers

      contestants.each do |contestant|
        csv << attributes.map{ |attr| contestant.send(attr) }
      end
    end
  end

  private

  def set_campaign_status_job

    queue = Sidekiq::ScheduledSet.new

    queue.select do |job|
      job.klass == "SetCampaignStatusJob" && job.args[0] == id
    end.each(&:delete)

    now = Time.now.in_time_zone(time_zone)

    if now.before?( starts_at ) && self.upcoming?
      SetCampaignStatusJob.perform_at( Time.parse(starts_at).utc, id )
    end

    if now.before?( ends_at ) && self.running?
      SetCampaignStatusJob.perform_at( Time.parse(ends_at).utc, id )
    end
  end

  def set_times_and_status

    return unless ( starts_at_changed? || ends_at_changed? || awarded_at_changed? )

    now = Time.now.in_time_zone(time_zone)

    self.starts_at  = starts_at.in_time_zone(time_zone)
    self.ends_at    = ends_at.in_time_zone(time_zone)
    self.awarded_at = awarded_at.in_time_zone(time_zone)

    if now.before?( starts_at )
      self.status = 0
    end

    if now.between?( starts_at, ends_at )
      self.status = 1
    end

    if now.after?( ends_at )
      self.status = 2
    end
  end

  def share_actions_override
    self.share_actions.each do |action|
      key = action[0]

      if key.eql?("email")
        self.share_actions[key] = "Share via #{key}"
      else
        self.share_actions[key] = "Share on #{key.capitalize}"
      end
    end
  end
 
  def set_url
    self.slug = "#{self.slug}-#{generate_token}"
  end

  def generate_token
    loop do
      token = SecureRandom.hex(1)
      break token unless self.class.exists?(slug: "#{self.slug}-#{token}")
    end
  end
end

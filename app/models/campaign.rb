require "csv"

class Campaign < ApplicationRecord
  paginates_per 100

  has_many :images, dependent: :destroy
  has_many :contestants, dependent: :destroy
  has_many :share_actions, dependent: :destroy
  has_many :bonus_entries, dependent: :destroy
  has_many :downloads, dependent: :destroy

  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :user

  accepts_nested_attributes_for :share_actions, allow_destroy: true
  accepts_nested_attributes_for :bonus_entries, allow_destroy: true

  validates :title, presence: true

  before_create :slug_override

  enum status: %i[ running stoped archived ]
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

  def campaign_time_out?
    DateTime.now.after?(self.awarded_at)
  end

  private

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
 
  def slug_override
    self.slug = "#{self.slug}-#{generate_slug_token}"
  end

  def generate_slug_token
    loop do
      token = SecureRandom.hex(1)
      break token unless self.class.exists?(slug: "#{self.slug}-#{token}")
    end
  end
end

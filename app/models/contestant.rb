class Contestant < ApplicationRecord
  paginates_per 100

  has_many :referred_contestants, class_name: "Contestant", foreign_key: :referred_by_id

  has_many :share_action_managements, dependent: :destroy
  has_many :share_action, -> { distinct }, through: :share_action_managements

  has_many :bonus_entry_managements, dependent: :destroy
  has_many :bonus_entry, -> { distinct }, through: :bonus_entry_managements

  belongs_to :campaign
  belongs_to :referred_by, class_name: "Contestant", optional: true

  validates :email, presence: true,
                    uniqueness: { scope: :campaign_id },
                    format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create

  validates :secret_code, :confirmation_token, :referral_code, uniqueness: true

  before_create :set_confirmation_token, :set_secret_code, :set_referral_code
  after_create :send_confirmation_email
  before_destroy :destroy_bonus_entry_managements, :destroy_share_action_managements

  private

  def send_confirmation_email
    if ContestantMailer.with(contestant: self).confirmation_email.deliver_later
      self.update(confirmation_sent_at: DateTime.now)
    end
  end

  def set_secret_code
    loop do
      self.secret_code = SecureRandom.hex(3).upcase
      break unless self.class.exists?(secret_code: secret_code)
    end
  end

  def set_referral_code
    loop do
      self.referral_code = SecureRandom.hex(6)
      break unless self.class.exists?(referral_code: referral_code)
    end
  end

  def set_confirmation_token
    loop do
      self.confirmation_token = SecureRandom.hex(10)
      break unless self.class.exists?(confirmation_token: confirmation_token)
    end
  end

  def destroy_bonus_entry_managements
    self.bonus_entry_managements.destroy_all
  end

  def destroy_share_action_managements
    self.share_action_managements.destroy_all
  end
end

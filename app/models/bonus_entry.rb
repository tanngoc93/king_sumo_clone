class BonusEntry < ApplicationRecord
  has_many :bonus_entry_managements
  has_many :contestant, -> { distinct }, through: :bonus_entry_managements
  
  belongs_to :campaign

  enum name: [
    :click_link,
    :twitter_follow,
    :facebook_like,
    :instagram_follow,
    :youtube_subscribe,
    :podcast_subscribe,
    :watch_youtube_video
  ]
end

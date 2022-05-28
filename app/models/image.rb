class Image < ApplicationRecord
  has_one_attached :data
  belongs_to :campaign
end

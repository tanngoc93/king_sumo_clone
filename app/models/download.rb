class Download < ApplicationRecord
  has_one_attached :data

  belongs_to :user
  belongs_to :campaign

  enum status: %i[ processing finished ]
end

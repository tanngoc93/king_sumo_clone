class ShareAction < ApplicationRecord
  has_many :share_action_managements
  has_many :contestant, -> { distinct }, through: :share_action_managements

  belongs_to :campaign

  enum name: %i[ email facebook messenger pinterest twitter ]

  before_create :set_action_points

  private

  def set_action_points
    self.action_points = 3
  end
end

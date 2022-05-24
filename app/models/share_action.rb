class ShareAction < ApplicationRecord
  belongs_to :campaign

  has_many :share_action_managements
  has_many :contestant, -> { distinct }, through: :share_action_managements

  before_create :set_action_points

  enum name: [
    :email,
    :facebook,
    :messenger,
    :pinterest,
    :twitter
  ]

  private
    def set_action_points
      self.action_points = 3
    end
end

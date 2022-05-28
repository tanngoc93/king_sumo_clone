class ShareActionManagement < ApplicationRecord
  belongs_to :contestant
  belongs_to :share_action

  after_create :increase_total_points

  private

  def increase_total_points
    contestant.update(total_points: contestant.total_points + share_action.action_points)
  end
end

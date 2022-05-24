class BonusEntryManagement < ApplicationRecord
  belongs_to :contestant
  belongs_to :bonus_entry

  after_create :increase_total_points

  private
    def increase_total_points
      contestant.update(total_points: contestant.total_points + bonus_entry.action_points)
    end
end

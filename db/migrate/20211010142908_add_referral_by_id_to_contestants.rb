class AddReferralByIdToContestants < ActiveRecord::Migration[6.1]
  def change
    add_column :contestants, :referred_by_id, :integer
  end
end

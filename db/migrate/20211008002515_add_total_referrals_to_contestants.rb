class AddTotalReferralsToContestants < ActiveRecord::Migration[6.1]
  def change
    add_column :contestants, :total_referrals, :integer, null: false, default: 0
  end
end

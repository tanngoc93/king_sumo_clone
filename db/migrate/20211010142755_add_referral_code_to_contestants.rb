class AddReferralCodeToContestants < ActiveRecord::Migration[6.1]
  def change
    add_column :contestants, :referral_code, :string
  end
end

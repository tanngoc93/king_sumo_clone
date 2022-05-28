class AddCampaignIdToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :campaign_id, :integer, require: false
    add_index :images, :campaign_id
  end
end

class CreateBonusEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :bonus_entries do |t|
      t.integer    :name
      t.string     :action_text
      t.string     :action_url
      t.integer    :action_points, null: false, default: 0
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end

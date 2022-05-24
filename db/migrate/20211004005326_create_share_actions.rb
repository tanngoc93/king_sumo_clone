class CreateShareActions < ActiveRecord::Migration[6.1]
  def change
    create_table :share_actions do |t|
      t.integer    :name, null: true
      t.string     :action_text
      t.string     :action_url
      t.integer    :action_points
      t.boolean    :checked, null: false, default: false
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end

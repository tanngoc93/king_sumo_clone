class CreateShareActionManagements < ActiveRecord::Migration[6.1]
  def change
    create_table :share_action_managements do |t|
      t.references :contestant, null: false, foreign_key: true
      t.references :share_action, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateBonusEntryManagements < ActiveRecord::Migration[6.1]
  def change
    create_table :bonus_entry_managements do |t|
      t.references :contestant, null: false, foreign_key: true
      t.references :bonus_entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end

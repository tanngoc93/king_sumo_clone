class AddConfirmedToContestants < ActiveRecord::Migration[6.1]
  def change
    add_column :contestants, :confirmed, :boolean, null: false, default: false
  end
end

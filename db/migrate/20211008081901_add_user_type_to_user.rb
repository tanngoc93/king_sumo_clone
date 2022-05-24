class AddUserTypeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_type, :integer, null: false, default: 0
  end
end

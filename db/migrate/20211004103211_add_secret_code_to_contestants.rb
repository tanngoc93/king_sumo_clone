class AddSecretCodeToContestants < ActiveRecord::Migration[6.1]
  def change
    add_column :contestants, :secret_code, :string
    add_index  :contestants, :secret_code, unique: true
  end
end

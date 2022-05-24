class CreateContestants < ActiveRecord::Migration[6.1]
  def change
    create_table :contestants do |t|
      t.string     :full_name
      t.string     :email
      t.string     :registered_ip
      t.string     :confirmation_token
      t.datetime   :confirmation_sent_at
      t.string     :confirmed_ip
      t.datetime   :confirmed_at
      t.string     :country_code
      t.integer    :total_points, null: false, default: 0
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end

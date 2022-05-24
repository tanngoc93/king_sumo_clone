class CreateCampaigns < ActiveRecord::Migration[6.1]
  def change
    create_table :campaigns do |t|
      t.string     :title
      t.text       :description
      t.datetime   :starts_at
      t.datetime   :ends_at
      t.datetime   :awarded_at
      t.string     :timezone
      t.boolean    :gdpr
      t.string     :offered_by_name
      t.string     :offered_by_url
      t.integer    :currency_unit, null: false, default: 0
      t.integer    :number_of_winners, null: false, default: 0
      t.string     :winner_prize_name
      t.float      :winner_prize_value, null: false, default: 0.0
      t.integer    :number_of_runners_up, null: false, default: 0
      t.string     :runner_up_prize_name
      t.float      :runner_up_prize_value, null: false, default: 0.0
      t.integer    :total_contestants, default: 0
      t.integer    :total_entries, default: 0
      t.integer    :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class AddRulesAndTermsToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :rules_and_terms, :text, default: ""
  end
end

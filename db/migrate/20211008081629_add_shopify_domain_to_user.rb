class AddShopifyDomainToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :shopify_domain, :string, null: true, unique: true
  end
end

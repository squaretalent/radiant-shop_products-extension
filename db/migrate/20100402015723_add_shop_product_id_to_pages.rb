class AddShopProductIdToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :shop_product_id, :integer
  end
  
  def self.down
    remove_column :pages, :shop_product_id
  end
end
class AddShopCategoryIdToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :shop_category_id, :integer
  end
  
  def self.down
    remove_column :pages, :shop_category_id
  end
end
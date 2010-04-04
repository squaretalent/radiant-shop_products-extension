class AddCustomLayoutsToCategory < ActiveRecord::Migration
  def self.up
    add_column :shop_categories, :custom_layout, :text
    add_column :shop_categories, :custom_product_layout, :text
  end

  def self.down
    remove_column :shop_categories, :custom_layout
    remove_column :shop_categories, :custom_product_layout
  end
end

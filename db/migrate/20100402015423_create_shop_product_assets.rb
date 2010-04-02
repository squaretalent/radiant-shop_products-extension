class CreateShopProductAssets < ActiveRecord::Migration
  def self.up
    create_table :shop_product_assets do |t|
      t.column :asset_id,   :integer
      t.column :product_id, :integer
      t.column :position,   :integer
    end
  end

  def self.down
    drop_table :shop_product_assets
  end
end
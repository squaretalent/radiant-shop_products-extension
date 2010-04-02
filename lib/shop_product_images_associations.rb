module ShopProductImages
  
  def self.included(base)
    base.class_eval {
      has_many :assets, :class_name => 'ShopProductAssets', :foreign_key => 'product_id'
      has_many :images, :through => :assets, :order => 'shop_product_assets.position ASC', :uniq => :true
    }
  end
  
end


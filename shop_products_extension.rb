require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_products_page_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_product_page_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_category_page_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_product_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_category_extensions"

class ShopProductsExtension < Radiant::Extension
  version "0.2"
  description "Describe your extension here"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
  define_routes do |map|
    map.namespace 'shop' do |shop|
      shop.connect ':handle', :controller => 'categories', :action => 'show'
      shop.connect ':category_handle/:handle', :controller => 'products', :action => 'show'
    end
  end
  
  def activate
    Page.class_eval { include ShopProductTags, ShopCategoryTags, ShopProductsPageExtensions }
    ShopProduct.class_eval { include ShopProductExtensions } #we want products to have images and slugs
    ShopCategory.class_eval { include ShopCategoryExtensions } #we want products to have layouts and slugs
    Asset.class_eval { include AssetShopProductImagesAssociations } #we want these images to be assets
        
    tab 'Shop' do
      add_item 'Products', '/admin/shop/products/categories'
    end
    
    admin.page.edit.add :layout_row, 'shop_category' if admin.respond_to?(:page)
    admin.page.edit.add :layout_row, 'shop_product' if admin.respond_to?(:page)

    # If our RadiantConfig settings are blank, set them up now
    Radiant::Config['shop.product_layout'] ||= 'ShopProduct'
    Radiant::Config['shop.category_layout'] ||= 'ShopCategory'
  end
end

require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_categories_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_category_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_category_page_extensions"

require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_products_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_product_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_product_page_extensions"

require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_products_page_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/shop_products_admin_ui"

class ShopProductsExtension < Radiant::Extension
  version "0.2"
  description "Describe your extension here"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
  define_routes do |map|   
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :shops, :as => 'shop', :only => [ :index ]
    end 
    map.namespace 'shop' do |shop|
      shop.product_search 'search.:format', :controller => 'products', :action => 'index', :conditions => { :method => :post }
      shop.product_search 'search/:query.:format', :controller => 'products', :action => 'index', :conditions => { :method => :get }
      shop.category ':handle.:format', :controller => 'categories', :action => 'show'
      shop.product ':category_handle/:handle.:format', :controller => 'products', :action => 'show'
    end
  end
  
  def activate
    unless defined? admin.products
      Radiant::AdminUI.send :include, ShopProductsAdminUI
      admin.products = Radiant::AdminUI.load_default_products_regions
      admin.categories = Radiant::AdminUI.load_default_categories_regions
    end
    
    Page.class_eval { include ShopProductTags, ShopCategoryTags, ShopProductsPageExtensions }
    
    ShopProduct.class_eval { include ShopProductExtensions } #we want products to have images and slugs
    Admin::Shop::ProductsController.send( :include, ShopProductsExtensions )
    
    ShopCategory.class_eval { include ShopCategoryExtensions } #we want products to have layouts and slugs
    Admin::Shop::Products::CategoriesController.send( :include, ShopCategoriesExtensions )
    
    tab 'shop' do
      add_item 'Products', '/admin/shop' #will redirect to shop_products
    end
    
    admin.page.edit.add :layout_row, 'shop_category' if admin.respond_to?(:page)
    admin.page.edit.add :layout_row, 'shop_product' if admin.respond_to?(:page)
    
    # If our RadiantConfig settings are blank, set them up now
    Radiant::Config['shop.product_layout'] ||= 'ShopProduct'
    Radiant::Config['shop.category_layout'] ||= 'ShopCategory'
  end
end

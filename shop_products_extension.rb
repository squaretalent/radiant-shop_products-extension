class ShopProductsExtension < Radiant::Extension
  version "0.2"
  description "Shop Products provides an interface for creating and retrieving products and their categories"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
  define_routes do |map|   
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :shops, :as => 'shop', :only => [ :index ]
    end 
    map.namespace 'shop' do |shop|
      shop.product_search 'search.:format', :controller => 'products', :action => 'index', :conditions => { :method => :post }
      shop.product_search 'search/:query.:format', :controller => 'products', :action => 'index', :conditions => { :method => :get }
      shop.categories 'categories', :controller => 'categories', :action => 'index'
      shop.category ':handle.:format', :controller => 'categories', :action => 'show'
      shop.product ':category_handle/:handle.:format', :controller => 'products', :action => 'show'
    end
  end
  
  def activate
    unless defined? admin.products
      Radiant::AdminUI.send :include, ShopProducts::AdminUI
      admin.products = Radiant::AdminUI.load_default_shop_products_regions
      admin.categories = Radiant::AdminUI.load_default_shop_categories_regions
    end
    Page.class_eval { include ShopProducts::ProductTags, ShopProducts::CategoryTags, ShopProducts::PageExtensions }
    ShopProduct.class_eval { include ShopProducts::ProductExtensions }
    ShopCategory.class_eval { include ShopProducts::CategoryExtensions }
    Admin::Shop::ProductsController.send( :include, ShopProducts::ProductsControllerExtensions )
    Admin::Shop::Products::CategoriesController.send( :include, ShopProducts::CategoriesControllerExtensions )
    
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

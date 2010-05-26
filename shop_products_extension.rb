class ShopProductsExtension < Radiant::Extension
  version "0.2"
  description "Shop Products provides an interface for creating and retrieving products and their categories"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
  define_routes do |map|   
    map.namespace :admin do |admin|
      admin.resources :shops, :as => 'shop', :only => [ :index ]
      admin.namespace :shop do |shop|
        shop.products_sort 'products/sort.:format', :controller => 'products', :action => 'sort', :conditions => { :method => :put }
        shop.categories_sort 'categories/sort.:format', :controller => 'categories', :action => 'sort', :conditions => { :method => :put }
      end
    end
    
    map.product_search  "#{Radiant::Config['shop.url_prefix']}/search.:format",                    :controller => 'shop/products',   :action => 'index', :conditions => { :method => :post }
    map.product_search  "#{Radiant::Config['shop.url_prefix']}/search/:query.:format",             :controller => 'shop/products',   :action => 'index', :conditions => { :method => :get }    
    map.shop_categories "#{Radiant::Config['shop.url_prefix']}/categories.:format",                :controller => 'shop/categories', :action => 'index', :conditions => { :method => :get }
    map.shop_product    "#{Radiant::Config['shop.url_prefix']}/:category_handle/:handle.:format",  :controller => 'shop/products',   :action => 'show',  :conditions => { :method => :get }
    map.shop_category   "#{Radiant::Config['shop.url_prefix']}/:handle.:format",                   :controller => 'shop/categories', :action => 'show',  :conditions => { :method => :get }
    
  end
  
  def activate
    unless defined? admin.products
      Radiant::AdminUI.send :include, ShopProducts::AdminUI
      admin.products = Radiant::AdminUI.load_default_shop_products_regions
      admin.categories = Radiant::AdminUI.load_default_shop_categories_regions
    end
    
    Page.send :include, ShopProducts::ProductTags, ShopProducts::CategoryTags, ShopProducts::PageExtensions
    ShopProduct.send :include, ShopProducts::ProductExtensions
    ShopCategory.send :include, ShopProducts::CategoryExtensions
    Admin::Shop::ProductsController.send :include, ShopProducts::ProductsControllerExtensions
    Admin::Shop::Products::CategoriesController.send :include, ShopProducts::CategoriesControllerExtensions
    
    # So that we can have a shop tab with children
    tab 'shop' do
      add_item 'Products', '/admin/shop' #will redirect to shop_products
    end
    
    admin.page.edit.add :layout_row, 'shop_category' if admin.respond_to? :page
    admin.page.edit.add :layout_row, 'shop_product' if admin.respond_to? :page
    
    # Ensure there is always a shop prefix, otherwise we'll lose admin and pages
    Radiant::Config['shop.url_prefix'] = Radiant::Config['shop.url_prefix'] == '' ? 'shop' : Radiant::Config['shop.url_prefix']

    # If our RadiantConfig settings are blank, set them up now
    Radiant::Config['shop.product_layout']  ||= 'Product'
    Radiant::Config['shop.category_layout'] ||= 'Products'
  end
end

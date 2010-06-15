ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.resources :shops, :as => 'shop', :only => [ :index ]
  end

  map.product_search "#{Radiant::Config['shop.url_prefix']}/search.:format", :controller => 'shop/products', :action => 'index', :conditions => { :method => :post }
  map.product_search "#{Radiant::Config['shop.url_prefix']}/search/:query.:format", :controller => 'shop/products',   :action => 'index', :conditions => { :method => :get }    
  map.shop_categories "#{Radiant::Config['shop.url_prefix']}/categories.:format", :controller => 'shop/categories', :action => 'index', :conditions => { :method => :get }
  map.shop_product "#{Radiant::Config['shop.url_prefix']}/:category_handle/:handle.:format", :controller => 'shop/products',   :action => 'show', :conditions => { :method => :get }
  map.shop_category "#{Radiant::Config['shop.url_prefix']}/:handle.:format", :controller => 'shop/categories', :action => 'show',  :conditions => { :method => :get }
  
end
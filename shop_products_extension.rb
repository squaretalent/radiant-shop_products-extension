# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ShopProductsExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/shop_products"

  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :shop_products
  #   end
  # end
  
  def activate
    # tab 'Content' do
    #   add_item "Shop Products", "/admin/shop_products", :after => "Pages"
    # end
  end
end

# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ShopProductsExtension < Radiant::Extension
  version "0.1"
  description "Describe your extension here"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
  def activate
    tab 'Shop' do
      add_item 'Products', '/admin/shop/products'
    end
  end
end

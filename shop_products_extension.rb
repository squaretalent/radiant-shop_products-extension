# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ShopProductsExtension < Radiant::Extension
  version "0.1"
  description "Describe your extension here"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
  def activate
    Page.class_eval { include ShopProductTags, ShopCategoryTags }
    ShopProduct.class_eval { include ShopProductImagesAssociations } #we want products to have images
    Asset.class_eval { include AssetShopProductImagesAssociations } #we want these images to be assets
        
    tab 'Shop' do
      add_item 'Products', '/admin/shop/products'
    end
    
    admin.page.edit.add :layout_row, 'shop_category' if admin.respond_to?(:page)
  end
end

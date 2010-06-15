class ShopProductsExtension < Radiant::Extension
  version "0.2"
  description "Shop Products provides an interface for creating and retrieving products and their categories"
  url "http://github.com/squaretalent/radiant-shop_products-extension"
  
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
    
    # Modify pages to allow for defining a product or category
    if admin.respond_to? :page
      admin.page.edit.add :layout_row, 'shop_category'
      admin.page.edit.add :layout_row, 'shop_product' 
    end
    
    # Ensure there is always a shop prefix, otherwise we'll lose admin and pages
    Radiant::Config['shop.url_prefix'] = Radiant::Config['shop.url_prefix'] == '' ? 'shop' : Radiant::Config['shop.url_prefix']

    Radiant::Config['shop.product_layout']  ||= 'Product'
    Radiant::Config['shop.category_layout'] ||= 'Products'
  end
end

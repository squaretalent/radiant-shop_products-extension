module ShopProducts
  module ProductsControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :initialize_meta_buttons_and_parts
        before_filter :assets
        before_filter :index_assets, :only => :index
        before_filter :edit_assets, :only => :edit
        
        def initialize_meta_buttons_and_parts
          @meta ||= []
          @meta << 'sku'
          @meta << 'category'
          
          @buttons_partials ||= []
        
          @parts ||= []
          @parts << {:title => 'images'}
          @parts << {:title => 'description'}
        end
        
        def assets
          include_stylesheet 'admin/extensions/shop/products/forms'
        end
        
        def index_assets
          include_javascript 'admin/dragdrop'
          include_javascript 'admin/extensions/shop/products/product_index'
          include_stylesheet 'admin/extensions/shop/products/product_index'
        end
        
        def edit_assets
          include_javascript 'admin/dragdrop'
          include_stylesheet 'admin/extensions/shop/products/product_edit'
          include_javascript 'admin/extensions/shop/products/product_edit'
        end
      end
    end
  end
end
module ShopProducts
  module ProductsControllerExtensions
    def self.included(base)
      base.class_eval do
        
        def sort
          @category = ShopCategory.find(params[:category_id])
          
          if @category
            @products = CGI::parse(params[:products])["shop_category_#{@category.id}_products[]"]
            @products.each_with_index do |id, index|
              ShopProduct.find(id).update_attributes({
                :position => index+1,
                :category_id => @category.id
              })
            end
          end
          
          render :text => @products.to_s
        end
        
        before_filter :initialize_meta_buttons_and_parts
        before_filter :assets
        before_filter :index_assets, :only => :index
        before_filter :edit_assets, :only => :edit
        
        def initialize_meta_buttons_and_parts
          @meta ||= []
          @meta << {:field => "sku", :type => "text_field", :args => [{:class => 'textbox', :maxlength => 160}]}
          @meta << {:field => "handle", :type => "text_field", :args => [{:class => 'textbox', :maxlength => 160}]}
        
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
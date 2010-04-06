module ShopProductsAdminUI

 def self.included(base)
   base.class_eval do
    
    attr_accessor :products
    attr_accessor :categories
    
    protected
      
      def load_default_products_regions
        returning OpenStruct.new do |products|
          products.edit = Radiant::AdminUI::RegionSet.new do |edit|
            edit.main.concat %w{edit_header edit_form edit_popups}
            edit.sidebar
            edit.form.concat %w{edit_title edit_extended_metadata edit_content}
            edit.form_bottom.concat %w{edit_buttons edit_timestamp}
          end
          products.new = products.edit
          products.index = Radiant::AdminUI::RegionSet.new do |index|
            index.top
            index.bottom.concat %w{ add_category }
            index.thead.concat %w{ title_header description_header modify_header }
            index.tbody.concat %w{
              cat_thumbnail_cell cat_title_cell cat_description_cell cat_add_product_cell cat_remove_cell
              prod_thumbnail_cell prod_title_cell prod_description_cell prod_remove_cell
            }
          end
          products.remove = products.index
        end
      end
      
      def load_default_categories_regions
        returning OpenStruct.new do |categories|
          categories.edit = Radiant::AdminUI::RegionSet.new do |edit|
            edit.main.concat %w{edit_header edit_form edit_popups}
            edit.form.concat %w{edit_title edit_extended_metadata edit_content}
            edit.form_bottom.concat %w{edit_buttons edit_timestamp}
          end
          categories.new = categories.edit
          categories.remove = categories.index
        end          
      end    
    end
  end
end


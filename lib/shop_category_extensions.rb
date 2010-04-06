module ShopCategoryExtensions
  
  def self.included(base)
    base.class_eval {
      def slug
        "/shop/category/#{handle}"
      end
      
      def layout
        result = custom_layout.blank? ? Radiant::Config['shop.category_layout'] : custom_layout
      end
      
      def product_layout
        result = custom_product_layout.blank? ? Radiant::Config['shop.product_layout'] : custom_product_layout
      end
    }
  end
  
end
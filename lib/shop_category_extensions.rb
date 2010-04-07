module ShopCategoryExtensions
  
  def self.included(base)
    base.class_eval {
      def after_initialize
        self.custom_layout = Radiant::Config['shop.category_layout'] if self.custom_layout.nil?
        self.custom_product_layout = Radiant::Config['shop.product_layout'] if self.custom_product_layout.nil?
      end
      
      def slug
        "/shop/category/#{handle}"
      end
      
      def layout
        custom_layout
      end
      
      def product_layout
        custom_product_layout
      end
    }
  end
  
end
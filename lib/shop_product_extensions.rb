module ShopProductExtensions
  
  def self.included(base)
    base.class_eval {
      def slug
        "/shop/product/#{handle}"
      end
      
      def layout
        category.product_layout
      end
    }
  end
  
end
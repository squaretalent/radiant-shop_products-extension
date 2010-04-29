module ShopProductExtensions
  
  def self.included(base)
    
    base.class_eval {
      def slug
        "/shop/#{self.category.handle}/#{handle}"
      end
      
      def layout
        category.product_layout
      end
      
      def assets_available
        Asset.search('', {:image => 1}) - self.assets
      end
    }
  end
  
end
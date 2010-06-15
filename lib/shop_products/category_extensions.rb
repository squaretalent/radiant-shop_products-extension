module ShopProducts
  module CategoryExtensions
    def self.included(base)
      base.class_eval do
        def after_initialize
          self.custom_layout = Radiant::Config['shop.category_layout'] if self.custom_layout.nil?
          self.custom_product_layout = Radiant::Config['shop.product_layout'] if self.custom_product_layout.nil?
        end
        
        def slug
          '/' + self.slug_prefix + '/' + self.handle
        end
      
        def layout
          custom_layout
        end
      
        def product_layout
          custom_product_layout
        end

        def slug_prefix
          Radiant::Config['shop.url_prefix']
        end
      end
    end
  end
end
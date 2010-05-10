module ShopProducts
  module PageExtensions
    class << self
      def included(base)
        base.belongs_to :shop_category, :class_name => 'ShopCategory', :foreign_key => 'shop_category_id'
        base.belongs_to :shop_product, :class_name => 'ShopProduct', :foreign_key => 'shop_product_id'
      end
    end
  end
end
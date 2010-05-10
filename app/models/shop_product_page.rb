class ShopProductPage < Page
  
  def current_shop_product
    @current_shop_product = ShopProduct.find(:first, :conditions => {:handle => self.slug})
  end
  
end
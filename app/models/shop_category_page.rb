class ShopCategoryPage < Page
  
  def current_shop_category
    @current_shop_category = ShopCategory.find(:first, :conditions => {:handle => self.slug})
  end
  
end
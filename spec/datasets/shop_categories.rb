class ShopCategoriesDataset < Dataset::Base
  def load
    categories = [ :bread, :salad ]
    
    categories.each do |category|
      create_record :shop_category, category, :title => category
    end
  end
end

class ShopCategoriesDataset < Dataset::Base
  def load
    categories = [ 'bread', 'salad' ]
    
    categories.each do |title|
      create_record :shop_category, title.to_sym, :title => title, :handle => title
    end
  end
end

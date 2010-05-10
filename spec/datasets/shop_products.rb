class ShopProductsDataset < Dataset::Base
  uses :shop_categories
  def load
    products = {
      'bread' => { 'white' => 3.20, 'wholemeal' => 3.10, 'multigrain' => 3.00 },
      'salad' => { 'green' => 7.00, 'caesar' => 9.00 }
    }
    
    products.each do |category, product|
      product.each do |title, price|
        create_record :shop_product, "#{title}_#{category}".to_sym, :title => title, :handle => title, :sku => title, :price => price, :category_id => shop_categories(category.to_sym)
      end
    end
  end
end

module ShopProductTags
  include Radiant::Taggable
  include ActionView::Helpers::NumberHelper
  
  class ShopProductTagError < StandardError; end
  
  tag 'shop:products' do |tag|
    tag.expand
  end
  
  tag 'shop:products:each' do |tag|
    content = ''
    products = tag.locals.category.products || ShopProduct.all
    
    products.each do |product|
      tag.locals.shop.product = product
      content << tag.expand
    end
    content
  end
  
  tag 'shop:product' do |tag|
    tag.locals.shop.product = find_shop_product(tag)
    tag.expand unless tag.locals.shop.product.nil?
  end

  [:title, :handle, :description].each do |symbol|
    tag "shop:product:#{symbol}" do |tag|
      unless tag.locals.shop.product.nil?
        hash = tag.locals.shop.product
        hash[symbol]
      end
    end
  end

  tag 'shop:product:price' do |tag|
    attr = tag.attr.symbolize_keys
    product = find_shop_product(tag)
    
    precision = attr[:precision] || 2
    precision = precision.to_i
    
    number_to_currency(product.price.to_f, 
                       :precision => precision,
                       :unit => attr[:unit] || "$",
                       :separator => attr[:separator] || ".",
                       :delimiter => attr[:delimiter] || ",")
  end
  
  tag 'shop:product:images' do |tag|
    tag.expand
  end
  
  tag 'shop:product:images:each' do |tag|
    content = ''
    product = find_shop_product(tag)
    
    products.images.each do |image|
      tag.locals.shop.product.image = image
      content << tag.expand
    end
    content
  end
  
  tag 'shop:product:image' do |tag|
    attr = tag.attr.symbolize_keys
    
    style = tag.attr[:style] || 'original'
    
    tag.locals.shop.product.image.thumbnail(style.to_sym) unless tag.locals.shop.product.nil? or tag.locals.shop.product.images.empty?
  end
  
protected

  def find_shop_product(tag)
    if tag.locals.shop.product
      tag.locals.shop.product
    elsif tag.attr['id']
      ShopProduct.find(tag.attr['id'])
    elsif tag.attr['handle']
      ShopProduct.find(:first, :conditions => {:handle => tag.attr['handle']})
    elsif tag.attr['title']
      ShopProduct.find(:first, :conditions => {:title => tag.attr['title']})
    elsif tag.attr['position']
      ShopProduct.find(:first, :conditions => {:position => tag.attr['position']})
    else
      ShopProduct.find(:first, :conditions => {:handle => tag.locals.page.slug})
    end
  end

end
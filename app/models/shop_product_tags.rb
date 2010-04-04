module ShopProductTags
  include Radiant::Taggable
  include ActionView::Helpers::NumberHelper
  
  class ShopProductTagError < StandardError; end
  
  tag 'shop:products' do |tag|
    tag.expand
  end
  
  tag 'shop:products:each' do |tag|
    content = ''
    products = tag.locals.shop_category.products || ShopProduct.all
    
    products.each do |product|
      tag.locals.shop_product = product
      content << tag.expand
    end
    content
  end
  
  tag 'shop:product' do |tag|
    tag.locals.shop_product = find_shop_product(tag)
    tag.expand unless tag.locals.shop_product.nil?
  end

  [:title, :handle, :price, :description].each do |symbol|
    tag "shop:product:#{symbol}" do |tag|
      unless tag.locals.shop_product.nil?
        hash = tag.locals.shop_product
        hash[symbol]
      end
    end
  end
  
  tag 'shop:product:link' do |tag|
    options = tag.attr.dup
    anchor = tag.locals.shop_product.slug
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : tag.render('title')
    %{<a href="#{anchor}"#{attributes}>#{text}</a>}
  end
  
  tag 'shop:product:slug' do |tag|
    tag.locals.shop_product.slug unless tag.locals.shop_product.nil?
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
    
    product.images.each do |image|
      tag.locals.shop_product_image = image
      content << tag.expand
    end
    content
  end
  
  tag 'shop:product:image' do |tag|
    attr = tag.attr.symbolize_keys
    image = find_shop_product_image(tag)
    
    style = tag.attr[:style] || 'original'
    
    image.thumbnail(style.to_sym) if image
  end
  
protected

  def find_shop_product(tag)
    if tag.locals.shop_product
      tag.locals.shop_product
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
  
  def find_shop_product_image(tag)
    if tag.locals.shop_product_image
      tag.locals.shop_product_image
    elsif tag.attr['id']
      tag.locals.shop_product.images.find(tag.attr['id'])
    elsif tag.attr['title']
      tag.locals.shop_product.images.find(:first, :conditions => {:title => tag.attr['title']})
    elsif tag.attr['position']
      asset = tag.locals.shop_product.assets.find(:first, :conditions => {:position => tag.attr['position']})
      
      if asset
        asset.image
      else
        nil
      end
    end
  end

end
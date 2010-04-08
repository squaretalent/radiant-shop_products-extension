module ShopProductTags
  include Radiant::Taggable
  include ActionView::Helpers::NumberHelper
  
  class ShopProductTagError < StandardError; end
  
  tag 'shop:products' do |tag|
    tag.expand
  end
  
  desc %{ iterates through each product within the scope }
  tag 'shop:products:each' do |tag|
    content = ''
    products = tag.locals.shop_category ? tag.locals.shop_category.products : ShopProduct.all
    
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

  [:title, :handle, :description].each do |symbol|
    desc %{ outputs the #{symbol} to the products generated page }
    tag "shop:product:#{symbol}" do |tag|
      unless tag.locals.shop_product.nil?
        hash = tag.locals.shop_product
        hash[symbol]
      end
    end
  end
  
  desc %{ generates a link to the products generated page }
  tag 'shop:product:link' do |tag|
    options = tag.attr.dup
    anchor = tag.locals.shop_product.slug
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : tag.render('title')
    %{<a href="#{anchor}"#{attributes}>#{text}</a>}
  end
  
  desc %{ outputs the slug to the products generated page }
  tag 'shop:product:slug' do |tag|
    tag.locals.shop_product.slug unless tag.locals.shop_product.nil?
  end

  desc %{ output price of product }
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
  
  desc %{ iterates through each of the products images }
  tag 'shop:product:images:each' do |tag|
    content = ''
    product = find_shop_product(tag)
    
    product.assets.each do |asset|
      tag.locals.shop_product_image = asset.image
      content << tag.expand
    end
    content
  end
  
  desc %{ output a products image. Use id, title or position to find a specific one}
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
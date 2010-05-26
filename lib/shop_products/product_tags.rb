module ShopProducts
  module ProductTags
    include Radiant::Taggable
    include ActionView::Helpers::NumberHelper
  
    class ShopProductTagError < StandardError; end
    
    desc %{ expands if there are products within the context }
    tag 'shop:if_products' do |tag|
      tag.expand unless find_shop_products(tag).empty?
    end
    
    desc %{ expands if there are not products within the context }
    tag 'shop:unless_products' do |tag|
      tag.expand if find_shop_products(tag).empty?
    end
    
    tag 'shop:products' do |tag|
      tag.expand
    end
  
    desc %{ iterates through each product within the scope }
    tag 'shop:products:each' do |tag|
      content   = ''
      products  = find_shop_products(tag)
    
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

    [:id, :title, :handle, :sku].each do |symbol|
      desc %{ outputs the #{symbol} to the products generated page }
      tag "shop:product:#{symbol}" do |tag|
        unless tag.locals.shop_product.nil?
          hash = tag.locals.shop_product
          hash[symbol]
        end
      end
    end
  
    desc %{ outputs the description to the products generated page }
    tag "shop:product:description" do |tag|
      unless tag.locals.shop_product.nil?
        parse(TextileFilter.filter(tag.locals.shop_product.description))
      end
    end
  
    desc %{ generates a link to the products generated page }
    tag 'shop:product:link' do |tag|
      options = tag.attr.dup
      product = find_shop_product(tag)
      anchor = product.slug
      attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
      attributes = " #{attributes}" unless attributes.empty?
      text = tag.double? ? tag.expand : tag.render('title')
      %{<a href="#{anchor}"#{attributes}>#{text}</a>}
    end
  
    desc %{ outputs the slug to the products generated page }
    tag 'shop:product:slug' do |tag|
      product = find_shop_product(tag)
      product.slug unless product.nil?
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
  
    desc %{ expands if the product has a valid image }
    tag 'shop:product:if_images' do |tag|
      tag.expand unless find_shop_product_image(tag).nil?
    end
    
    desc %{ expands if the product does not have a valid image }
    tag 'shop:product:unless_images' do |tag|
      tag.expand if find_shop_product_image(tag).nil?
    end
  
    tag 'shop:product:images' do |tag|
      tag.expand
    end
  
    desc %{ iterates through each of the products images }
    tag 'shop:product:images:each' do |tag|
      content = ''
      product = find_shop_product(tag)
    
      product.images.each do |image|
        tag.locals.shop_product_image = image
        content << tag.expand
      end
      content
    end
  
    desc %{ output a products image. Use id, title or position to find a specific one}
    tag 'shop:product:image' do |tag|
      attrs = tag.attr.symbolize_keys
      image = find_shop_product_image(tag)
      tag.locals.shop_product_image = image
      
      style = attrs[:style] || 'original'
    
      image.thumbnail(style.to_sym) if image
    end
  
    [:id, :position].each do |symbol|
      desc %{ output the #{symbol}  about a product image}
      tag "shop:product:#{symbol}" do |tag|
        image = find_shop_product_image(tag)
        image[symbol]
      end
    end
  
  protected  
  
    def find_shop_products(tag)
      if @shop_products
        @shop_products
      elsif params[:query]
        ShopProduct.search(params[:query])
      elsif tag.locals.shop_category
        tag.locals.shop_category.products
      else
        ShopProduct.all
      end
    end
  
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
      elsif !ShopProduct.all.empty?
        ShopProduct.find(:first, :conditions => {:handle => tag.locals.page.slug})
      else
        nil
      end
    end
  
    def find_shop_product_image(tag)
      if tag.locals.shop_product_image
        image = tag.locals.shop_product_image
      elsif tag.attr['id']
        image = tag.locals.shop_product.images.find(tag.attr['id'])
      elsif tag.attr['title']
        image = tag.locals.shop_product.images.find(:first, :conditions => {:title => tag.attr['title']})
      elsif tag.attr['position']
        image = tag.locals.shop_product.images.find(:first, :conditions => {:position => tag.attr['position']})
      else
        image = tag.locals.shop_product.images.first
      end
      
      result = nil
      unless image.nil?
        result = image.asset unless image.asset.nil?
      end
      
      result
    end

  end
end
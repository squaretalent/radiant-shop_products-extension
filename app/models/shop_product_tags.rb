module ShopProductsTags
  include Radiant::Taggable
  include ERB::Util
  
  include ActionView::Helpers::NumberHelper
  
  tag 'shop:products' do |tag|
    tag.expand
  end
  
  desc "Iterate over all products, optionally sorted by the field specified by 'order', or constrained by 'where'"
  tag 'shop:products:each' do |tag|
    attr = tag.attr.symbolize_keys
    order=attr[:order] || 'position DESC'
    where=attr[:where]
    result = []
    
    if tag.locals.shop.category
      products=tag.locals.category.products.find(:all, :conditions => where, :order => order)
    else
      products=ShopProduct.find(:all, :conditions => where, :order => order)
    end
    
    products.each do |product|
      tag.locals.shop.product = product
      result << tag.expand
    end
    result
  end
  
  desc "Renders contained tags in reference to the product"
  tag 'shop:product' do |tag|
    tag.expand
  end

  desc "Find a specific product by any available conditions, eg 'id', 'sku', 'handle', 'price'"
  tag 'shop:product:find' do |tag|
    attr = tag.attr.symbolize_keys

    conditions = []
    attr.each do |key, val|
      conditions << "LOWER(#{key.to_s}) LIKE (#{val.downcase})"
    end
    conditions = conditions.join(" AND ")

    product = ShopProduct.find(:first, :conditions => conditions)
    
    if category then
      tag.locals.shop.product = product
      tag.expand
    else
      "<span class='error'>Can't find product</span>"
    end
  end
  
  desc "Renders the HTML-escaped title of the current product loaded by <r:product> or <r:products:each>"
  tag 'shop:product:title' do |tag|
    product = tag.locals.shop.product
    html_escape product.title
  end

  desc "Renders the price of the current product loaded by <r:product> or <r:products:each>.<br />
        Formatting can be specified by 'precision', 'unit', 'separator' and 'delimiter'"
  tag 'shop:product:price' do |tag|
    attr = tag.attr.symbolize_keys
    product = tag.locals.shop.product
    precision = attr[:precision]
    if precision.nil? then
      precision=2
    else
      precision=precision.to_i
    end
    number_to_currency(product.price.to_f, 
                       :precision => precision,
                       :unit => attr[:unit] || "$",
                       :separator => attr[:separator] || ".",
                       :delimiter => attr[:delimiter] || ",")
  end
  
  desc "Renders the description of the current product loaded by <r:product> or <r:products:each>"
  tag 'shop:product:description' do |tag|
    product = tag.locals.shop.product
    html_escape product.description
  end
  
  desc "TODO Loops through all images associated with a product"
  tag 'shop:product:images' do |tag|
    "<span class='error'>Haven't done this yet</span>"
  end
  
  desc "Loops through all categories in the shop"
  tag 'shop:categories' do |tag|
    tag.expand
  end

  desc "Iterate over all categories either in the system or the scoped category, ['order', 'where', 'parent']"
  tag 'shop:categories:each' do |tag|
    attr = tag.attr.symbolize_keys
    order=attr[:order] || 'position DESC'
    where=attr[:where]

    if attr[:parent] =~ /^\d+$/
      parent = attr[:parent].to_i
    else
      parent = nil
    end
    parent = "parent_id = #{parent}"

    where=[where, parent].compact.join(' AND ')

    result = []
    if tag.locals.shop.category
      categories=tag.locals.shop.category.children.find(:all, :conditions => where, :order => order)
    else
      categories=ShopCategory.find(:all, :conditions => where, :order => order)
    end
    categories.each do |category|
      tag.locals.shop.category = category
      result << tag.expand
    end
    result
  end
  
  desc "Renders contained tags in reference to the category"
  tag 'shop:category' do |tag|
    tag.expand
  end
  
  desc "Find a specific category by any available conditions, eg 'id', 'handle', 'title'"
  tag 'shop:category:find' do |tag|
    attrs = tag.attr.symbolize_keys

    conditions = []
    attrs.each do |key, attr|
      conditions << "LOWER(#{key.to_s}) LIKE (#{attr.downcase})"
    end
    conditions = conditions.join(" AND ")

    product = ShopCategory.find(:first, :conditions => conditions)
    
    if category then
      tag.locals.shop.category = category
      tag.expand
    else
      "<strong class='error'>Can't find category</strong>"
    end
  end

end
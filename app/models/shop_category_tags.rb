module ShopCategoryTags
  include Radiant::Taggable
  include ERB::Util
  
  class ShopCategoryTagError < StandardError; end

  tag 'shop:categories' do |tag|
    tag.expand
  end

  tag 'shop:categories:each' do |tag|
    content = ''
    categories = ShopCategory.all
    
    categories.each do |category|
      tag.locals.category = category
      content << tag.expand
    end
    content
  end

  tag 'shop:category' do |tag|
    tag.locals.shop_category = find_shop_category(tag)
    tag.expand unless tag.locals.shop_category.nil?
  end
  
  [:title, :handle].each do |symbol|
    tag "shop:category:#{symbol}" do |tag|
      unless tag.locals.shop_category.nil?
        hash = tag.locals.shop_category
        hash[symbol]
      end
    end
  end

  tag 'shop:category:link' do |tag|
    options = tag.attr.dup
    anchor = tag.locals.shop_category.slug
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : tag.render('title')
    %{<a href="#{anchor}"#{attributes}>#{text}</a>}
  end
  
  tag 'shop:category:slug' do |tag|
    tag.locals.shop_category.slug unless tag.locals.shop_category.nil?
  end
  
  tag 'shop:category:if_products' do |tag|
    category = find_shop_category(tag)
    tag.expand if category && !category.products.empty?
  end
  
  tag 'shop:category:unless_items' do |tag|
    category = find_shop_category(tag)
    tag.expand if !category || category.products.empty?
  end
  
protected

  def find_shop_category(tag)
    if tag.locals.shop_category
      tag.locals.shop_category
    elsif tag.attr['id']
      ShopCategory.find(tag.attr['id'])
    elsif tag.attr['handle']
      ShopCategory.find(:first, :conditions => {:handle => tag.attr['handle']})
    elsif tag.attr['title']
      ShopCategory.find(:first, :conditions => {:title => tag.attr['title']})
    elsif tag.attr['position']
      ShopCategory.find(:first, :conditions => {:position => tag.attr['position']})
    else
      ShopCategory.find(:first, :conditions => {:handle => tag.locals.page.slug})
    end
  end

end
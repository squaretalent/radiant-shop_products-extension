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
    tag.locals.shop.category = find_shop_category(tag)
    tag.expand unless tag.locals.shop.category.nil?
  end
  
  [:title, :handle].each do |symbol|
    tag "shop:category:#{symbol}" do |tag|
      unless tag.locals.shop.category.nil?
        hash = tag.locals.shop.category
        hash[symbol]
      end
    end
  end
  
  tag 'shop:category:slug' do |tag|
    tag.locals.shop.category.slug unless tag.locals.shop.category.nil?
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
    if tag.locals.shop.category
      tag.locals.shop.category
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
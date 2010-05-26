module ShopProducts
  module CategoryTags
    include Radiant::Taggable
    include ERB::Util
  
    class ShopCategoryTagError < StandardError; end

    desc %{ expands if there are shop categories within the context }
    tag 'shop:if_categories' do |tag|
      tag.expand unless find_shop_categories(tag).empty?
    end

    desc %{ expands if there are not shop categories within the context }
    tag 'shop:unless_categories' do |tag|
      tag.expand if find_shop_categories(tag).empty?
    end
    
    tag 'shop:categories' do |tag|
      tag.expand
    end

    desc %{ iterates through each product category }
    tag 'shop:categories:each' do |tag|
      content = ''
      categories = find_shop_categories(tag)
    
      categories.each do |category|
        tag.locals.shop_category = category
        content << tag.expand
      end
      content
    end

    tag 'shop:category' do |tag|
      tag.locals.shop_category = find_shop_category(tag)
      tag.expand unless tag.locals.shop_category.nil?
    end
  
    tag 'shop:category:if_current' do |tag|
      page        = tag.locals.page
      category    = find_shop_category(tag)
      product     = find_shop_product(tag)
    
      if (category and category.handle == page.slug) or (product and category == product.category)
        tag.expand
      end
    end
  
    [:title, :handle, :description, :slug].each do |symbol|
      desc %{ outputs the #{symbol} of the current product category }
      tag "shop:category:#{symbol}" do |tag|
        category = find_shop_category(tag)
        unless category.nil?
          hash = tag.locals.shop_category
          hash[symbol]
        end
      end
    end

    desc %{ returns a link to the current category }
    tag 'shop:category:link' do |tag|
      options = tag.attr.dup
      category = find_shop_category(tag)
      attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
      attributes = " #{attributes}" unless attributes.empty?
      text = tag.double? ? tag.expand : tag.render('title')
      %{<a href="#{category.slug}" #{attributes}>#{text}</a>}
    end
  
  protected
  
    def find_shop_categories(tag)
      if params[:query]
        ShopCategory.search(params[:query])
      else
        ShopCategory.all
      end
    end
  
    def find_shop_category(tag)
      if tag.locals.shop_category
        tag.locals.shop_category
      elsif tag.locals.shop_product
        tag.locals.shop_product.category
      elsif tag.attr['id']
        ShopCategory.find(tag.attr['id'])
      elsif tag.attr['handle']
        ShopCategory.find(:first, :conditions => {:handle => tag.attr['handle']})
      elsif tag.attr['title']
        ShopCategory.find(:first, :conditions => {:title => tag.attr['title']})
      elsif tag.attr['position']
        ShopCategory.find(:first, :conditions => {:position => tag.attr['position']})
      elsif !ShopCategory.all.empty?
        ShopCategory.find(:first, :conditions => {:handle => tag.locals.page.slug})
      else
        nil
      end
    end

  end
end
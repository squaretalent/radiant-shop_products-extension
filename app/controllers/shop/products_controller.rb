class Shop::ProductsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  no_login_required  
  radiant_layout Radiant::Config['shop.product_layout']
  
  # GET /shop/search/:query
  # GET /shop/search/:query.js
  # GET /shop/search/:query.xml
  # GET /shop/search/:query.json                                  AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    before_filter { |c| c.include_stylesheet 'admin/extensions/shop/products/products' }
    before_filter { |c| c.include_javascript 'admin/pagefactory' }
    @shop_products = ShopProduct.search(params[:query])
    
    unless @shop_products.empty?
      @radiant_layout = Radiant::Config['shop.category_layout']

      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/shop/products/products', :collection => @shop_products }
        format.xml { render :xml => @shop_products.to_xml(attr_hash) }
        format.json { render :json => @shop_products.to_json(attr_hash) }
      end
    else
      render :template => 'site/not_found', :status => 404
    end
  end
  
  # GET /shop/:category_handle/:handle
  # GET /shop/:category_handle/:handle.js
  # GET /shop/:category_handle/:handle.xml
  # GET /shop/:category_handle/:handle.json                       AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_product = ShopProduct.find(:first, :conditions => ['LOWER(handle) = ?', params[:handle]])
    @shop_category = @shop_product.category unless @shop_product.nil?
    
    unless @shop_product.nil?
      @title = @shop_product.title
      @radiant_layout = @shop_product.layout
      
      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/shop/products/product', :locals => { :product => @shop_product } }
        format.xml { render :xml => @shop_product.to_xml(attr_hash) }
        format.json { render :json => @shop_product.to_json(attr_hash) }
      end
    else
      render :template => 'site/not_found', :status => 404
    end
  end
  
end
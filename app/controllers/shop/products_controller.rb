class Shop::ProductsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  no_login_required  
  radiant_layout Radiant::Config['shop.product_layout']
  
  def index
    @shop_products = ShopProduct.search(params[:query])
    
    unless @shop_products.empty?
      @radiant_layout = Radiant::Config['shop.category_layout']

      respond_to do |format|
        format.html { render }
        format.js { render :partial => '/shop/products/products', :collection => @shop_product }
        format.xml { render :xml => @shop_product.to_xml(attr_hash) }
        format.json { render :json => @shop_product.to_json(attr_hash) }
      end
    else
      render :template => 'site/not_found', :status => 404
    end
  end
  
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
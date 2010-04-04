class Shop::ProductsController < ApplicationController
  radiant_layout 'ShopProduct'
  no_login_required
  
  def show
    @shop_category=ShopCategory.find(:first, :conditions => ['LOWER(handle) = ?', params[:category_handle]])
    @shop_product=ShopProduct.find(:first, :conditions => ['LOWER(handle) = ?', params[:handle]])
    
    if @shop_product
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
class Admin::ShopsController < ApplicationController

  # GET /admin/shop/products                                               HTML
  #----------------------------------------------------------------------------
  def index
    redirect_to admin_shop_products_path
  end
  
end
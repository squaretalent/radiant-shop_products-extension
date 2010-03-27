class Admin::Shop::CategoriesController < Admin::ResourceController
  
  # GET /shop/products/categories/1/products.js                            AJAX
  #----------------------------------------------------------------------------
  def products
    
    super
    
    respond_to do |format|
      format.js { render :partial => '/admin/shop/products/excerpt', :collection => @shop_category.products }
    end
    
  end
    
end
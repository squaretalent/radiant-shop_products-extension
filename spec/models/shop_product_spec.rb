require File.dirname(__FILE__) + '/../spec_helper'

describe ShopProduct do
  dataset :shop_products
  
  before(:each) do
    @shop_product = shop_products(:white_bread)
    @shop_category = shop_products(:white_bread).category
    
    #@shop_product.stubs(:assets)
    #Assets.stubs(:search).and_returns([assets(:asset_one, :asset_two)])
  end
  
  it "should return its categories product_layout" do
    @shop_product.layout.should eql(@shop_category.product_layout)
  end
  
  it "should return all assets minus itself for assets_available"
  
  it "should generate a shop.url_prefix based url" do
    @shop_product.slug.should eql(@shop_product.slug_prefix + '/' + @shop_product.category.handle + '/' + @shop_product.handle)
  end
  
end
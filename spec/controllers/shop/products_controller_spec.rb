require File.dirname(__FILE__) + '/../../spec_helper'

describe Shop::ProductsController do
  
  describe "index" do 
    # it "should expose products list" do
    #   get :index
    #   assigns(:shop_products).should eql(ShopProducts)
    # end
    
    it "should return 404 if products empty" do
      get :index
      @controller.stub!(:shop_products).and_return(Array)
      response.should be_not_found
    end
  end
  
  describe "#show" do
    it "should return 404 if product empty" do
      get :index
      @controller.stub!(:shop_product).and_return(nil)
      response.should be_not_found
    end
  end
  
end
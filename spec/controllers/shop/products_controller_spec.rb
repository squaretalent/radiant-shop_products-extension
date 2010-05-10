require File.dirname(__FILE__) + '/../../spec_helper'

describe Shop::ProductsController do
  before(:each) do 
    @bread = mock_model(ShopCategory, :title => 'bread', :handle => 'white_bread', :custom_layout => Radiant::Config['shop.category_layout'], :custom_product_layout => Radiant::Config['shop.product_layout'])
    @white_bread = mock_model(ShopProduct, :title => 'white bread', :handle => 'white_bread', :sku => 'white_bread', :price => 3.00, :category => @bread, :layout => Radiant::Config['shop.product_layout'])
    @wholemeal_bread = mock_model(ShopProduct, :title => 'wholemeal bread', :handle => 'wholemeal_bread', :sku => 'wholemeal_bread', :price => 3.10, :category => @bread, :layout => Radiant::Config['shop.product_layout'])

    @shop_category = @bread
    @shop_product = @white_bread
    @shop_products = [@white_bread, @wholemeal_bread]
  end
  
  describe "index" do    
    it "should expose products list" do
      ShopProduct.stub!(:search).and_return(@shop_products)
      get :index
      
      response.should be_success
    end
    
    it "should return 404 if products empty" do
      ShopProduct.stub!(:search).and_return([])
      get :index
      
      response.should render_template('site/not_found')
    end
  end
  
  describe "#show" do
    it "should expose product" do
      ShopProduct.stub!(:find).and_return(@shop_product)
      get :show
      
      response.should be_success
    end
    
    it "should return 404 if product empty" do
      ShopProduct.stub!(:find).and_return(nil)
      get :show
      
      response.should render_template('site/not_found')
    end
  end
  
end
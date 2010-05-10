require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ShopsController do
  dataset :users
  
  describe "index" do    
    it "should only be accessible by logged in users" do
      get :index
      
      response.should redirect_to(login_path)
    end
    
    it "should redirect to shop products" do
      login_as :admin
      get :index
      
      response.should redirect_to(admin_shop_products_path)
    end
  end
  
end
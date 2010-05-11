require File.dirname(__FILE__) + '/../../spec_helper'

describe ShopProducts::ProductTags do
  dataset :pages
  dataset :shop_products
  
  class ProductTags
    include Radiant::Taggable
    include ShopProducts::ProductTags
  end
  
  before(:each) do
    @shop_product = shop_products(:white_bread)
    @shop_products = [shop_products(:white_bread), shop_products(:wholemeal_bread), shop_products(:multigrain_bread)]
  end
  
  describe '<r:shop:products>' do
    it 'should expand' do
      tag = '<r:shop:products>success.</r:shop:products>'
      expected = %{success.}
      pages(:home).should render(tag).as(expected)
    end
    
    describe '<r:shop:products:each' do
      
      it 'should expand if products is set' do
        pending
        raise ProductTags.find_shop_products.inspect
        ProductTags.stub!(:find_shop_products).and_return([])
        
        tag = '<r:shop:products:each>success.</r:shop:products:each>'
        expected = %{success.success.}
        pages(:home).should render(tag).as(expected)
      end
      
      it 'should expand if query is set'
      
      it 'should expand if shop_category is set'
      
      it 'should expand if none of these are set and there are products'
      
      it 'should not expand if there are no products'
    end
    
  end
end
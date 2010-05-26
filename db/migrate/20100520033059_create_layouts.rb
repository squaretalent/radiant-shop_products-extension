class CreateLayouts < ActiveRecord::Migration
  def self.up
    # Will only create a layout if it doesn't exist
    Layout.create({
      :name => 'Application',
      :content => <<-CONTENT
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <title><r:title /></title>
  </head>
  <body>
    <r:content_for_layout />
  </body>
</html>
CONTENT
    })
    
    Layout.create({
      :name => Radiant::Config['shop.product_layout'],
      :content => <<-CONTENT
<r:inside_layout name='Application'>
  <r:shop:product>
    <div id="shop_product_<r:handle />" class="shop_product">
      <h2><r:title /></h2>
      <h3><r:price /></h3>
      <div id="shop_product_description">
        <h3>Description</h3>
        <div class="body"><r:description /></div>
      </div>
      <r:if_images>
        <ul id="shop_product_images">
          <r:images:each>
            <li class="shop_product_image" id="shop_product_image_<r:handle />">
              <a href="<r:image style='normal' />" title="<r:title />"">  
                <img id="shop_product_image_<r:position />" class="shop_product_image" src="<r:image style='thumbnail'/>" alt="<r:title />" />
              </a>
            </li>
          </r:images:each>
        </ul>
      </r:if_images>
      <r:unless_images>
        <p class="error" id="shop_no_product_images_error">We don't have any images for this product yet.</p>
      </r:unless_images>
    </div>
  </r:shop:product>
</r:inside_layout>
CONTENT
    })
    Layout.create({
      :name => Radiant::Config['shop.category_layout'],
      :content => <<-CONTENT
<r:inside_layout name='Application'>
  <r:shop:category>
    <div id="shop_category_<r:handle />" class="shop_category">
      <h2 class="shop_category_title"><r:title /></h2>
      <div id="shop_category_description">
        <h3>Description</h3>
        <div class="body"><r:description /></div>
      </div>
      <r:if_products>
        <ul class="shop_products" id="shop_products_<r:handle/>" >
        <r:products:each>
          <r:product>
            <li class="shop_product" id="shop_product_<r:handle />">
              <r:link><img src="<r:image style='thumbnail' />" alt="<r:handle />" class="shop_product_image" /></r:link>
              <h3 class="shop_product_title"><r:link><r:title /> <small><r:price /></small></r:link></h3>
              <div class="shop_product_description"><r:description /></div>
            </li>
          </r:product>
        </r:products:each>
        </ul>
      </r:if_products>
      <r:unless_products>
        <p class="error" id="shop_no_products_error">We don't have any products available here yet.</p>
      </r:unless_products>
    </div>
  </r:shop:category>
</r:inside_layout>
CONTENT
    })
  end

  def self.down
    # Won't delete content, that would be cruel
  end
end

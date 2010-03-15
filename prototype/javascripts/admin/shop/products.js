//  Select Shop Category
//    Category exists, and has a name as well as products
//    Update primary window to display category and first product
//    Update products list to show all products
var SelectShopCategory = Behavior.create({
  onclick : function(e) {        
    new Ajax.Request('/admin/products.json', { 
      method: 'get',
      onSuccess: function(data) {
        $('shop_products_list').innerHTML = "";
        products = data.responseText.evalJSON();
        
        products.each(function(product) {
          li    = new Element('li', { 'class' : "product", 'id' : "shop_product-" + product.sku });
          span  = new Element('span', { 'class' : "title" })
          a     = new Element('a', { 'href' : "/product/" + product.sku })
          
          $('shop_products_list').appendChild(li.insert(span.insert(a.insert(product.title))));
        });
        // Fire click event for first anchor
        $('shop_product').show();
      },
      onFailure: function(data) {
        $('shop_products_list').innerHTML = "<p>Something went wrong</p>";
      }
    });
    
    $('shop_product_category_title').value = this.element.text;
    
    return false;
  }
});

//  Select Shop Product
//    Product exists, has a name and infinite properties
//    Update primary window to display all the product details
var SelectShopProduct = Behavior.create({
  onclick : function(e) {
    $('shop_product_name').value = this.element.text;
    $('shop_product').show();
    return false;
  }
})

var CreateShopCategory = Behavior.create({
  onclick : function(e) {
    $('shop_product_category_title').value = "";
    $('shop_product').hide();
    return false;
  }
});

Event.addBehavior({
  'div#shop_product_details': TabControlBehavior(),
  
  '#shop_product_categories_list a:not(.new)': SelectShopCategory(),
  '#shop_products_list a:not(.new)': SelectShopProduct(),
  
  '#shop_product_categories_list a.new': CreateShopCategory()
});
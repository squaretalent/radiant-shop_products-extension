//  Select Shop Category
//    Category exists, and has a name as well as products
//    Update primary window to display category and first product
//    Update products list to show all products
var SelectShopCategory = Behavior.create({
  onclick : function(e) {
    UpdateShopCategory(this.element);
    UpdateShopProducts();
    return false;
  }
});

//  Select Shop Product
//    Product exists, has a name and infinite properties
//    Update primary window to display all the product details
var SelectShopProduct = Behavior.create({
  onclick : function(e) {
    UpdateShopProduct(this.element);
    return false;
  }
})

//  Create Shop Category
//    Clear out categories and products
//    Primary window is now a blank slate for a new category
var CreateShopCategory = Behavior.create({
  onclick : function(e) {
    UpdateShopCategory(this.element);
    NewShopCategory();
    return false;
  }
});

function UpdateShopCategory(category) {
  $('shop_product_categories_list').down('a.current').removeClassName('current');
  category.addClassName('current');
  
  $('shop_product_category_title').value = category.text;
}

function NewShopCategory() {
  $('shop_products_list').innerHTML = "";
  $('shop_product_category_title').value = "";
  $('shop_product').hide();
}

function UpdateShopProduct(product) {
  var product_id = null;
  
  if(product == "first") {
    $('shop_products_list').down('a').addClassName('current');
    //product_id = 1;
  } else {
    $('shop_products_list').down('a.current').removeClassName('current');
    product.addClassName('current');
    //product_id = this.element.getAttribute('product_id');
  }
  
  $('shop_product').show();
}

function UpdateShopProducts() {
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
      UpdateShopProduct("first");
    },
    onFailure: function(data) {
      $('shop_products_list').innerHTML = "<p>Something went wrong</p>";
    }
  });
}

Event.addBehavior({
  'div#shop_product_details': TabControlBehavior(),
  
  '#shop_product_categories_list a:not(.new)': SelectShopCategory(),
  '#shop_products_list a:not(.new)': SelectShopProduct(),
  
  '#shop_product_categories_list a.new': CreateShopCategory()
});
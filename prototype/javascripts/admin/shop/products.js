document.observe("dom:loaded", function() {
  shop = new Shop();
});

var DisableClickBehaviour = Behavior.create({
  onclick : function(e) {
    return false;
  }
});

//  Select Shop Category
//    Category exists, and has a name as well as products
//    Update primary window to display category and first product
//    Update products list to show all products
var SelectShopCategory = Behavior.create({
  onclick : function(e) {
    shop.SelectCategory(this.element);
  }
});

//  Select Shop Product
//    Product exists, has a name and infinite properties
//    Update primary window to display all the product details
var SelectShopProduct = Behavior.create({
  onclick : function(e) {
    shop.SelectProduct(this.element);
  }
})

//  Create Shop Category
//    Clear out categories and products
//    Primary window is now a blank slate for a new category
var CreateShopCategory = Behavior.create({
  onclick : function(e) {
    shop.SelectCategory(this.element);
    shop.CreateCategory();
  }
});

var Shop = Class.create({
  SelectCategory: function(category) {
    $('shop_product_categories_list').down('a.current').removeClassName('current');
    category.addClassName('current');
    
    $('shop_product_category_title').value = category.text;
    
    new Ajax.Request('/admin/categories/' + category.readAttribute("data-id") + '.json?' + new Date().getTime(), { 
      method: 'get',
      onSuccess: function(data) {
        this.response = data.responseText.evalJSON();
        this.UpdateCategoryProducts();
      }.bind(this),
    });
  },
  
  CreateCategory: function() {
    $('shop_products_list').innerHTML = "";
    $('shop_product_category_title').value = "";
    $('shop_product').hide();
    $('shop_product_create').hide();
  },
  
  UpdateCategoryProducts: function() {
    $('shop_products_list').innerHTML = "";
    
    this.response.products.each(function(product) {
      li    = new Element('li', { 'class' : "product", 'id' : "shop_product-" + product.sku });
      span  = new Element('span', { 'class' : "title" });
      a     = new Element('a', { 'href' : "/product/" + product.sku, 'data-id' : product.id, 'data-sku' : product.sku });
      
      $('shop_products_list').appendChild(li.insert(span.insert(a.insert(product.title))));
    });
    
    this.SelectProduct("first");
    $('shop_product_create').show();
  },
  
  SelectProduct: function(product) {
    if(product == "first") {
      product = $('shop_products_list').down('a');
    } else {
      $('shop_products_list').down('a.current').removeClassName('current');
    }
    
    product.addClassName('current');
    
    new Ajax.Request('/admin/products/' + product.readAttribute("data-id") + '.json?' + new Date().getTime(), { 
      method: 'get',
      onSuccess: function(data) {
        this.response.product = data.responseText.evalJSON();
        this.UpdateProduct();
      }.bind(this),
    });
    
    $('shop_product').show();
  },
  
  UpdateProduct: function() {
    $('shop_product_name').value = this.response.product.title;
    $('shop_product_price').value = this.response.product.price;
    $('shop_product_handle').value = this.response.product.handle;
  }
});

Event.addBehavior({
  
  '#shop_product_categories_list li a, #shop_products_list li a': DisableClickBehaviour(),
  
  '#shop_product_categories_list li a': SelectShopCategory(), // TODO only call this on non-current and non-new
  '#shop_products_list li a': SelectShopProduct(),
  
  '#shop_product_categories_list a.new': CreateShopCategory(),
  
  'div#shop_product_details': TabControlBehavior()
});
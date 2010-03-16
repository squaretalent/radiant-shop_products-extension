document.observe("dom:loaded", function() {
  shop = new Shop();
  $('shop_product').hide();
  $$('.clearable').each(function(input) {
    input.value = '';
  })
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
    shop.UpdateCategory(this.element);
  }
});

//  Create Shop Category
//    Clear out categories and products
//    Primary window is now a blank slate for a new category
var CreateShopCategory = Behavior.create({
  onclick : function(e) {
    shop.SelectCategory(this.element);
    shop.CreateCategory();
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

//  Create Shop Product
//    Primary window will be the product category and blank product window
var CreateShopProduct = Behavior.create({
  onclick : function(e) {
    shop.CreateProduct();
  }
});

var Shop = Class.create({
  SelectCategory: function(category) {
    try {
      $('shop_product_categories_list').down('a.current').removeClassName('current');
    } catch(err) {
      //why do i have to do this
    }
    category.addClassName('current');
  },
  
  UpdateCategory: function(category) {
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
      try {
        $('shop_products_list').down('a.current').removeClassName('current');
      } catch(err) {
        //why do i have to do this
      }
    }
    
    product.addClassName('current');
    
    new Ajax.Request('/admin/products/' + product.readAttribute("data-id") + '.json?' + new Date().getTime(), { 
      method: 'get',
      onSuccess: function(data) {
        this.response = data.responseText.evalJSON();
        this.UpdateProduct();
      }.bind(this),
    });    
  },
  
  UpdateProduct: function() {
    $('shop_product').show();
    $('shop_product_category_title').value = this.response.category.title;
    $('shop_product_title').value = this.response.title;
    $('shop_product_price').value = this.response.price;
    $('shop_product_handle').value = this.response.handle;
  },
  
  CreateProduct: function() {
    $('shop_product_inputs').select('input').value = '';
  }
});

Event.addBehavior({
  
  '#shop_product_categories_list li a, #shop_products_list li a, #shop_product_category_create, #shop_product_create': DisableClickBehaviour(),
  
  '#shop_product_categories_list li a': SelectShopCategory(), // TODO only call this on non-current and non-new
  '#shop_products_list li a': SelectShopProduct(),
  
  '#shop_product_category_create a': CreateShopCategory(),
  '#shop_product_create a': CreateShopProduct(),
  
  'div#shop_product_details': TabControlBehavior()
});
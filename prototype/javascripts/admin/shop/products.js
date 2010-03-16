//  Select Shop Category
//    Category exists, and has a name as well as products
//    Update primary window to display category and first product
//    Update products list to show all products
var SelectShopCategory = Behavior.create({
  onclick : function(e) {
    shop = new Shop();
    shop.UpdateCategory(this.element);
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

var Shop = Class.create({
  UpdateCategory: function(category) {    
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
  
  UpdateCategoryProducts: function() {
    $('shop_products_list').innerHTML = "";

    this.response.products.each(function(product) {
      li    = new Element('li', { 'class' : "product", 'id' : "shop_product-" + product.sku });
      span  = new Element('span', { 'class' : "title" });
      a     = new Element('a', { 'href' : "/product/" + product.sku, 'data-id' : product.id, 'data-sku' : product.sku });

      $('shop_products_list').appendChild(li.insert(span.insert(a.insert(product.title))));
    });
    UpdateShopProduct("first");
  }
});

function NewShopCategory() {
  $('shop_products_list').innerHTML = "";
  $('shop_product_category_title').value = "";
  $('shop_product').hide();
}

function UpdateShopProduct(product) {
  var product_id = null;
  
  if(product == "first") {
    $('shop_products_list').down('a').addClassName('current');
    product_id = 1;
  } else {
    $('shop_products_list').down('a.current').removeClassName('current');
    product.addClassName('current');
    product_id = product.getAttribute('product_id');
  }
  
  $('shop_product').show();
}

function UpdateShopProducts(products) {

}

Event.addBehavior({
  'div#shop_product_details': TabControlBehavior(),
  
  '#shop_product_categories_list a:not(.new)': SelectShopCategory(),
  '#shop_products_list a:not(.new)': SelectShopProduct(),
  
  '#shop_product_categories_list a.new': CreateShopCategory()
});
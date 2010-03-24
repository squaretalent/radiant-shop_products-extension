var ShopProducts = {};
var ShopCategories = {};

document.observe("dom:loaded", function() {
  
  shop = new Shop();
  shop.ProductClear();
  shop.CategorySelect($('shop_category_create'));
  
  Event.addBehavior({
    '#shop_categories .category': ShopCategories.List,
    '#shop_category_form': ShopCategories.Form,
    '#shop_products .product': ShopProducts.List,
    
    '#shop_product_details': TabControlBehavior()
  });
  
});

ShopCategories.List = Behavior.create({
  onclick : function() {
    shop.CategorySelect(this.element);
  }
});

ShopCategories.Form = Behavior.create({
  onsubmit : function() {
    shop.CategorySubmit(this.element);
    
    return false;
  }
})

ShopProducts.List = Behavior.create({
  onclick : function(e) {
    shop.ProductSelect(this.element);
  }
});

var Shop = Class.create({
  
  CategorySelect: function(element) { 
    this.CategoryClear();
    this.ProductClear();

    element.addClassName('current');
    element.stopObserving('click');
    
    if(element.getAttribute('data-id') == '') {
      $('shop_product').hide();
      $('shop_product_alt').show();
      $('shop_products_alt').show();
      $('shop_product_create').hide();
      $('shop_category_submit').value = 'create';
    } else {
      $('shop_category_title').value = element.readAttribute('data-title');
      $('shop_category_submit').value = 'update';
      
      new Ajax.Request($('admin_shop_categories_path').value + '/' + element.readAttribute('data-id') + '/products.js?' + new Date().getTime(), { 
        method: 'get',
        onSuccess: function(data) {
          
          // Ready to show UI
          $('shop_category').show();
          $('shop_product_create').show();

          // Fill Products List
          $('shop_products_list').innerHTML = data.responseText;
          
          // Select First Product
          this.ProductSelect($('shop_products_list').down('.product'));
        }.bind(this),
      });
    }
  },
  
  CategorySubmit: function(element) {
    console.log(element.serialize(true));
  },
  
  CategoryCreate: function() {
    // Call back from controller create
  },
  
  CategoryUpdate: function(element) {
    // Call back from controller update
  },
  
  CategoryClear: function() {
    $$('#shop_categories .category.current').each(function(element) { 
      element.removeClassName('current'); 
      ShopCategories.List.attach(element); 
    });
    
    $$('#shop_category .clearable').each(function(input) {
      input.value = '';
    });
    
    // Get Products List Ready
    $('shop_products_alt').hide();
    $('shop_products_list').innerHTML = '';
  },
  
  ProductSelect: function(element) {
    this.ProductClear();
    element.stopObserving('click');
    
    element.addClassName('current');
    
    $('shop_product_alt').hide();
    if(element.getAttribute('data-id') == '') {
    
      $('shop_product').show();
      $('shop_product_submit').value = 'create';
    
    } else {

      new Ajax.Request($('admin_shop_products_path').value + '/' + element.readAttribute("data-id") + '.json?' + new Date().getTime(), { 
        method: 'get',
        onSuccess: function(data) {
          this.response = data.responseText.evalJSON();
          
          // Update product form
          $('shop_product_title').value = this.response.title;
          $('shop_product_price').value = this.response.price;
          $('shop_product_handle').value = this.response.handle;
          $('shop_product_sku').value = this.response.sku;
          $('shop_product_submit').value = 'update';
        

          $('shop_product').show();
        }.bind(this),
      });
    }
  },
  
  ProductCreate: function() {
    // Call back from controller create
  },
  
  ProductUpdate: function(element) {
    // Call back from controller update
  },
  
  ProductClear: function() {
    $$('.product.current').each(function(element) { 
      element.removeClassName('current'); 
      ShopProducts.List.attach(element);
    });
        
    $$('#shop_product .clearable').each(function(input) {
      input.value = '';
    });
    
    $('shop_product').hide();
  }
  
});
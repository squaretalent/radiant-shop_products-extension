var ShopProducts = {};
var ShopCategories = {};

document.observe("dom:loaded", function() {
  
  shop = new Shop();
  shop.ProductClear();
  shop.CategoryClear();
  
  Event.addBehavior({
    '#shop_product_categories .category': ShopCategories.List,
    '#shop_products .product': ShopProducts.List,
    
    'div#shop_product_details': TabControlBehavior()
  });
  
});

var ShopCategories.List = Behavior.create({
  onclick : function() {
    shop.CategorySelect(this.element);
  }
});

var ShopProducts.List = Behavior.create({
  onclick : function(e) {
    shop.ProductSelect(this.element);
  }
});

var Shop = Class.create({
  
  CategorySelect: function(element) { 
    this.CategoryClear();
    this.ProductClear();
    
    element.addClassName('current');
    
    if(element.getAttribute('data-id') == '') {
      $('shop_product').hide();
      $('shop_product_create').hide();
      $('shop_products_list').innerHTML = '';
    } else {
      $('shop_product_category_title').value = element.text;
      
      new Ajax.Request('/admin/categories/' + element.readAttribute("data-id") + '.js?' + new Date().getTime(), { 
        method: 'get',
        onSuccess: function(data) {
          
          // Ready to show UI
          $('shop_product_category').show();
          $('shop_product_create').show();
          
          // Fill Products List
          $('shop_products_list').innerHTML = data.responseText;
          
          // Select First Product
          this.ProductSelect($('shop_products_list').down('.product'));
        }.bind(this),
      });
    }
  },
  
  CategoryCreate: function() {
    // Call back from controller create
  },
  
  CategoryUpdate: function(element) {
    // Call back from controller update
  },
  
  CategoryClear: function() {
    $$('.category.current').each(function(element) { 
      element.removeClassName('current'); 
      Galleries.List.attach(element); 
    });
    
    $$('#shop_product_category .clearable').each(function(input) {
      input.value = '';
    });
    
    $('shop_product_category').hide();
  },
  
  ProductSelect: function(product) {
    this.productClear();
    
    $$('.product.current').each(function(element) { 
      element.removeClassName('current'); 
    });
    
    new Ajax.Request('/admin/products/' + product.readAttribute("data-id") + '.json?' + new Date().getTime(), { 
      method: 'get',
      onSuccess: function(data) {
        this.response = data.responseText.evalJSON();
        
        $('shop_product_category_id').value = this.response.category.id;
        $('shop_product_category_title').value = this.response.category.title;
        $('shop_product_title').value = this.response.title;
        $('shop_product_price').value = this.response.price;
        $('shop_product_handle').value = this.response.handle;
        
        $('shop_product').show();
        $('shop_product_category').show();
        
        product.addClassName('current');
      }.bind(this),
    });
  },
  
  ProductCreate: function() {
    // Call back from controller create
  },
  
  ProductUpdate: function(element) {
    // Call back from controller update
  },
  
  ProductClear: function() {
    $$('#shop_product .clearable').each(function(input) {
      input.value = '';
    });
    
    $('shop_product').hide();
  }
  
});
var ShopProducts = {};
var ShopCategories = {};

document.observe("dom:loaded", function() {
  shop = new Shop();
  shop.ProductClear();
  shop.CategorySelect($('shop_category_create'));
  
  Event.addBehavior({
    '#shop_categories .delete': ShopCategories.Destroy,
    '#shop_categories .category': ShopCategories.List,
    '#shop_category_form': ShopCategories.Form,
    
    '#shop_products .product': ShopProducts.List,
    '#shop_product_form': ShopProducts.Form,
    '#shop_product_delete': ShopProducts.Destroy,
    
    '#shop_product_details': TabControlBehavior()
  });
});

ShopCategories.List = Behavior.create({
  onclick : function() {
    shop.CategorySelect(this.element);
  }
});

ShopCategories.Destroy = Behavior.create({
  onclick : function() {
    if(confirm("Really Delete Category?")) {
      shop.CategoryDestroy(this.element.up('.category'));
      shop.CategorySelect($('shop_category_create'));
    }
    return false;
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

ShopProducts.Form = Behavior.create({
  onsubmit : function(e) {
    shop.ProductSubmit(this.element);
    return false;
  }
});

ShopProducts.Destroy = Behavior.create({
  onclick : function() {
    if(confirm("Really Delete Product?")) {
      shop.ProductDestroy($('shop_products_list').down('.current'));
      shop.ProductSelect($('shop_product_create'));
    }
    return false;
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
      $('shop_category_method').value = 'post';
      $('shop_category_form').setAttribute('action', urlify($('admin_shop_categories_path').value));
      
    } else {
      showStatus("Loading...");
      $('shop_category_id').value = element.readAttribute('data-id');
      $('shop_category_title').value = element.readAttribute('data-title');
      $('shop_category_submit').value = 'update';
      $('shop_category_method').value = 'put';
      $('shop_category_form').setAttribute('action', urlify($('admin_shop_categories_path').value,element.readAttribute('data-id')));
      
      new Ajax.Request(urlify($('admin_shop_categories_path').value, element.readAttribute('data-id') + '/products'), { 
        method: 'get',
        onSuccess: function(data) {
          setStatus("Finished!"); 
          
          // Ready to show UI
          $('shop_category').show();
          $('shop_product_create').show();
          
          // Fill Products List
          $('shop_products_list').innerHTML = data.responseText;
          
          // Select First Product
          this.ProductSelect($('shop_product_create'));
          hideStatus();
        }.bind(this),
      });
    }
  },
  
  CategorySubmit: function(element) {
    this.data = element.serialize(true);
    this.element = element;
    
    if(this.data._method == 'post') { showStatus('Creating...'); }
    else { showStatus('Saving...'); }
    
    new Ajax.Request(element.action + '?' + new Date().getTime(), { 
      method: this.data._method,
      parameters: this.data,
      onSuccess: function(data) {
        this.response = data.responseText;
        hideStatus();
        
        if(this.data._method == 'post') { this.CategoryCreate(); } 
        else { this.CategoryUpdate(); }
      }.bind(this),
    });
  },
  
  CategoryCreate: function() {
    $('shop_categories_list').insert({'top': this.response});
    
    var element = $('shop_categories_list').down();
    
    ShopCategories.List.attach(element);
    this.CategorySelect(element);
  },
  
  CategoryUpdate: function(element) {
    var element = $('shop_categories_list').down('.current');
    
    // This replaces the current item with the returned html
    element = element.replace(this.response); 
    
    // element is still the old item, but the id is the same as the new, so call on that id
    $(element.id).addClassName('current');
    $(element.id).stopObserving('click');
  },
  
  CategoryDestroy: function(element) {
    showStatus('Deleting...');
    element.hide();
    new Ajax.Request(urlify($('admin_shop_categories_path').value, element.readAttribute('data-id')), { 
      method: 'delete',
      onSuccess: function(data) {
        element.remove();
        hideStatus();
      }.bind(this),
      onFailure: function(data) {
        element.show();
        alert(data.responseText);
        hideStatus();
      }.bind(this)
    });
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
    
    $('shop_product_category_id').value = $('shop_category_id').value;
    
    if(element.getAttribute('data-id') == '') {
      $('shop_product').show();
      $('shop_product_submit').value = 'create';
      $('shop_product_method').value = 'post';
      $('shop_product_form').setAttribute('action', urlify($('admin_shop_products_path').value));
    } else {
      showStatus("Loading...");
      new Ajax.Request(urlify($('admin_shop_products_path').value,element.readAttribute("data-id")), { 
        method: 'get',
        onSuccess: function(data) {
          setStatus("Finished!");
          this.response = data.responseText;
          
          $('shop_product').innerHTML = this.response;
          
          $('shop_product_submit').value = 'update';
          $('shop_product_method').value = 'put';
          $('shop_product_form').setAttribute('action', urlify($('admin_shop_products_path').value, element.readAttribute('data-id')));
          
          $('shop_product').show();
          hideStatus();
        }.bind(this),
      });
    }
  },
  
  ProductSubmit: function(element) {
    this.data = element.serialize(true);
    this.element = element;
    
    if(this.data._method == 'post') { showStatus("Creating..."); }
    else { showStatus("Saving..."); }
    
    new Ajax.Request(element.action + '?' + new Date().getTime(), { 
      method: this.data._method,
      parameters: this.data,
      onSuccess: function(data) {
        this.response = data.responseText;
        hideStatus();

        if(this.data._method == 'post') { this.ProductCreate(); } 
        else { this.ProductUpdate(); }
      }.bind(this),
    });
  },
  
  ProductCreate: function() {  
    $('shop_products_list').insert({'top': this.response});

    var element = $('shop_products_list').down();

    ShopProducts.List.attach(element);
    this.ProductSelect(element);
  },
  
  ProductUpdate: function(element) {
    // Explained in CategoryUpdate
    var element = $('shop_products_list').down('.current');
    
    element = element.replace(this.response); 
    
    $(element.id).addClassName('current');
    $(element.id).stopObserving('click');
  },
  
  ProductDestroy: function(element) {
    showStatus('Deleting...')
    element.hide();
    new Ajax.Request(urlify($('admin_shop_products_path').value, element.readAttribute('data-id')), { 
      method: 'delete',
      onSuccess: function(data) {
        element.remove();
        hideStatus();
      }.bind(this),
      onFailure: function(data) {
        element.show();
        alert(data.responseText);
        hideStatus();
      }.bind(this)
    });
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

function urlify(route, id) {
  var url = route;
  if ( id !== undefined ) {
    url += '/' + id
  }
  
  url += '.js?' + new Date().getTime();
  
  return url;
}
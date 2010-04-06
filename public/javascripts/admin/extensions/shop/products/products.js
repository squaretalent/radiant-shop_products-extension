var ShopProductAssets = {};

document.observe("dom:loaded", function() {
  shop = new Shop();
  shop.ProductInitialize();
  
  Event.addBehavior({
    '#asset_popup_close:click' : function(e) { shop.ProductAssetClear(); },
    '#asset_form:submit' : function(e) { shop.ProductAssetSubmit(); },
    
    '#assets_list .asset:click' : function(e) { shop.ProductImageCreate($(this)); },
    '#images_list .image .actions .delete:click' : function(e) { shop.ProductImageDestroy($(this).up('.image'))}
  });
});

ShopProductAssets.List = Behavior.create({
  
  onclick: function() { 
    shop.ProductImageCreate(this.element);
  }
  
});

var Shop = Class.create({
  
  ProductInitialize: function() {
    if($('shop_product_id')) {
      this.ProductImageList();
    }
  },
  
  ProductImagesSort: function() {
    Sortable.create('images_list', {
      constraint: false, 
      overlap: 'horizontal',
      containment: ['images_list'],
      onUpdate: function(element) {
        new Ajax.Request(urlify($('admin_shop_product_images_sort_path').value), {
          method: 'put',
          parameters: {
            'product_id': $('shop_product_id').value,
            'images':Sortable.serialize('images_list')
          }
        });
      }.bind(this)
    });
  },
  
  ProductImageList: function(element) {
    showStatus('Loading Images...');
    new Ajax.Request(urlify($('admin_shop_product_images_path').value), {
      method: 'get',
      parameters: { 
        'product_id' : $('shop_product_id').value
      },
      onSuccess: function(data) {   
        setStatus('All Done');     
        $('images_list').innerHTML = data.responseText;
        this.ProductAssetList();
        this.ProductImagesSort();
      }.bind(this)
    });
  },
  
  ProductImageCreate: function(element) {
    showStatus('Adding Image...');
    element.hide();
    new Ajax.Request(urlify($('admin_shop_product_images_path').value), {
      method: 'post',
      parameters: {
        'product_id' : $('shop_product_id').value,
        'shop_product_image[asset_id]' : element.getAttribute('data-id')
      },
      onSuccess: function(data) {
        // Insert item into list, re-call events
        $('images_list').insert({ 'bottom' : data.responseText});
        shop.ProductImagesSort();
        
        element.remove();
        hideStatus();
      }.bind(element),
      onFailure: function() {
        element.show();
        hideStatus();
      }
    });
  },
  
  ProductImageDestroy: function(element) {
    showStatus('Deleting Image...');
    element.hide();
    new Ajax.Request(urlify($('admin_shop_product_images_path').value, element.readAttribute('data-id')), { 
      method: 'delete',
      onSuccess: function(data) {
        $('assets_list').insert({ 'bottom' : data.responseText });
        shop.ProductAssetList();
        element.remove();
        hideStatus();
      }.bind(this),
      onFailure: function(data) {
        element.show();
        hideStatus();
      }.bind(this)
    });
  },
  
  ProductAssetList: function() {
    setStatus('Loading Everything Else...');
    new Ajax.Request(urlify($('admin_shop_product_assets_path').value), {
      method: 'get',
      parameters: { 
        'filter[image]' : 1,
        'product_id' : $('shop_product_id').value
      },
      onSuccess: function(data) {   
        setStatus('All Done');     
        $('assets_list').innerHTML = data.responseText;
        hideStatus();
      }
    });
  },
  
  ProductAssetSubmit: function() {
    showStatus('Uploading Image...');
  },
  
  ProductAssetCreate: function() {
    ShopProductAssets.List.attach($("assets_list").down(".asset"));
    this.ProductImageCreate($("assets_list").down(".asset"));
    this.ProductAssetClear();
    
    hideStatus();
    
    return null;
  },
  
  ProductAssetClear: function() {
    Element.closePopup('asset_popup');
    
    $$('#asset_form .clearable').each(function(input) {
      input.value = '';
    });
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
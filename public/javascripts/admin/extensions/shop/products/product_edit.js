var ShopProductAssets = {}

document.observe("dom:loaded", function() {
  shop = new Shop()
  shop.ProductInitialize()
  
  Event.addBehavior({
    '#image_browse_popup_close:click' : function(e) { shop.ImageClose() },
    '#image_form_popup_close:click' : function(e) { shop.ImageClose() },
    
    '#image_form:submit' : function(e) { shop.ImageSubmit() },
    
    '#image_browse_popup .image:click' : function(e) { shop.ProductImageCreate($(this)) },
    '#product_images_list .delete:click' : function(e) { shop.ProductImageDestroy($(this).up('.image')) }
  })
})

ShopProductAssets.List = Behavior.create({
  
  onclick: function() { 
    shop.ProductImageCreate(this.element)
  }
  
});

var Shop = Class.create({
  
  ProductInitialize: function() {
    if($('shop_product_id')) {
      this.ProductImagesSort()
    }
  },
  
  ProductImagesSort: function() {
    Sortable.create('product_images_list', {
      constraint: false, 
      overlap: 'horizontal',
      containment: ['product_images_list'],
      onUpdate: function(element) {
        new Ajax.Request(urlify($('admin_shop_product_sort_images_path').value), {
          method: 'put',
          parameters: {
            'product_id': $('shop_product_id').value,
            'product_images':Sortable.serialize('product_images_list')
          }
        });
      }.bind(this)
    })
  },
  
  ProductImageCreate: function(element) {
    showStatus('Adding Image...')
    element.hide()
    new Ajax.Request(urlify($('admin_shop_product_images_path').value), {
      method: 'post',
      parameters: {
        'product_id' : $('shop_product_id').value,
        'shop_product_image[image_id]' : element.getAttribute('data-image_id')
      },
      onSuccess: function(data) {
        // Insert item into list, re-call events
        $('product_images_list').insert({ 'bottom' : data.responseText})
        shop.ProductImagesSort()
        
        element.remove()
        hideStatus()
      }.bind(element),
      onFailure: function() {
        element.show()
        hideStatus()
      }
    });
  },
  
  ProductImageDestroy: function(element) {
    showStatus('Removing Image...');
    element.hide();
    new Ajax.Request(urlify($('admin_shop_product_images_path').value, element.readAttribute('data-product_image_id')), { 
      method: 'delete',
      onSuccess: function(data) {
        $('images_list').insert({ 'bottom' : data.responseText })
        element.remove()
        hideStatus()
      }.bind(this),
      onFailure: function(data) {
        element.show();
        hideStatus();
      }.bind(this)
    });
  },
  
  ImageSubmit: function() {
    showStatus('Uploading Image...')
  },
  
  ProductAssetCreate: function() {
    ShopProductAssets.List.attach($("assets_list").down(".asset"));
    this.ProductImageCreate($("assets_list").down(".asset"));
    this.ProductAssetClear();
    
    hideStatus();
    
    return null;
  },
  
  ImageClose: function() {
    Element.closePopup('image_form_popup')
    Element.closePopup('image_browse_popup')
    
    $$('#image_browse_form .clearable').each(function(input) {
      input.value = ''
    })
  }
  
})

function urlify(route, id) {
  var url = route
  if ( id !== undefined ) {
    url += '/' + id
  }
  
  url += '.js?' + new Date().getTime()
  
  return url
}
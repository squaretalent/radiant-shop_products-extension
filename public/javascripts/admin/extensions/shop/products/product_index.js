var ShopProducts = {}

document.observe("dom:loaded", function() {
  shop = new Shop()
  shop.ProductsInitialize()
  
  Event.addBehavior({
    // empty
  })
})

var Shop = Class.create({
  
  ProductsInitialize: function() {
    if($('products_map')) {
     this.ProductsSort()
     this.CategoriesSort()
    }
  },
  
  
  CategoriesSort: function() {
    Sortable.create('shop_categories', {
      overlap: 'vertical',
      only: 'category',
      handle: 'handle',
      onUpdate: function() {
        new Ajax.Request('/admin/shop/categories/sort', {
          method: 'put',
          parameters: {
            'categories':Sortable.serialize('shop_categories')
          }
        })
      }
    })
  },
  
  ProductsSort: function() {
    var categories = Array()
    $$('li.category').each(function(el, i) {
      categories[i] = $(el).id + '_products'
    })
    
    categories.each(function(category) { 
      Sortable.create(category, {
        overlap: 'vertical',
        only: 'product',
        handle: 'handle',
        dropOnEmpty: true,
        hoverclass: 'hover',
        containment: categories,
        onUpdate: function() {
          new Ajax.Request('/admin/shop/products/sort', {
            method: 'put',
            parameters: {
              'category_id': $(category).readAttribute('data-id'),
              'products':Sortable.serialize(category)
            }
          })
        }.bind(this)
      })
    })
  }
  
})
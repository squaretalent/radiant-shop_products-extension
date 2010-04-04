= Shop Products

Allows a store owner to add products and product categories to a store.

== Route Navigation

/shop/:category
/shop/:category/:product

These routes are automatically generated and allow the store owner to simply stick with one
interface to generate the content.

Extending the details of a product involves coding in additional fields and extending the interface

== Page Based Navigation

Alternatively you can create Page Types which align a page to a product/category. This means
you can generate custom navigation (categories with categories as children) and having additional
fields is as easy as creating more parts and updating the layout

*PageFactories will really help out with this*

== Learn From Me

This extension relies on "shop":http://github.com/squaretalent/radiant-shop-extension and has adopted
a few features which were originally a part of core. Check out /lib to see how we extends objects, 
create relations to products and assets and generally do awesome things.

This will really help you in extending things yourself.
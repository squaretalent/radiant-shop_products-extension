module ShopProducts
  module CategoriesControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :initialize_meta_buttons_and_parts
      
        def initialize_meta_buttons_and_parts
          @meta ||= []
          @meta << {:field => "handle", :type => "text_field", :args => [{:class => 'textbox', :maxlength => 160}]}
        
          @buttons_partials ||= []
        
          @parts ||= []
          @parts << {:title => 'description'}
        end
      end
    end
  end
end
ActionController::Routing::Routes.draw do |map|
  map.resources :events

  map.resources :photos

  map.resources :photographers

  map.resources :event_types

  map.resources :users

  map.root :controller => "events", :action => "index"

  map.resources :events, :has_many => [:photos]

  map.resources :photographers, :has_one => [:user], :has_many =>[:photos]

  map.login "login", :controller => "users", :action => "login"
  map.logout "logout", :controller => "users", :action => "logout"

  map.connect 'upload/photo', :controller => "upload", :action => "photo"
  map.upload "upload", :controller => "upload", :action => "index"

  map.cart 'cart/:action/:id', :controller => 'cart'

  map.resources :payment_notifications

  map.photos 'photos/:action/:id', :controller => 'photos'

  map.resources :event_types, :has_many => [:events]

  map.not_authenticated 'error401', :controller => "static", :action => 'error401'
  map.contact 'contact', :controller=>'static', :action=>'contact'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

     map.namespace :admin do |admin|
       # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
       admin.resources :photographers, :name_prefix=>'admin_'
       admin.resources :photos, :name_prefix=>'admin_'
       admin.resources :events, :name_prefix=>'admin_'
       admin.tag 'tag', :controller=>'phototagger', :action=>'tag', :name_prefix=>'admin_'
       admin.tag_show 'tag/:action/:id', :controller=>'phototagger', :name_prefix=>'admin_'
     end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
  map.connect ':slug', :controller=>"photos", :action=>"index_events_slug"
end

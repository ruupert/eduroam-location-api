Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root 'welcome#index'
      get 'doc' => 'welcome#doc'
      get ':apikey/get/ssids' => 'ssids#get'
      get ':apikey/get/locations' => 'locations#get', :as => 'get_locations'
      get ':apikey/set/location/:address/:identifier/:city/:ap' => 'entries#set', :as => 'set_location'
      get ':apikey/set/location/:address/:identifier/:city/:ap/:ssid' => 'entries#set', :as => 'set_location_with_ssid'
      get ':apikey/get/policies' => 'orgpolicies#get'
      match ':apikey/set/policy/lang/:lang/*url' => 'orgpolicies#set', :via => :get, :format => false, constraints: { url: /\D*/ }
      get ':apikey/get/infos' => 'orginfos#get'
      match ':apikey/set/info/lang/:lang/*url' => 'orgpinfos#set', :via => :get, :format => false, constraints: { url: /\D*/ }
      get ':apikey/get/loc_names' => 'loc_names#get'
      match ':apikey/set/loc_name/:location_id/lang/:lang/*name' => 'loc_names#set', :via => :get, :format => false, constraints: { url: /\D*/ }

    end
  end

  root 'welcome#index'
  get 'apidoc' => 'welcome#apidoc'
  get 'exporter/institutions'
  get 'import' => 'institutions#new_import'
  post '/institution/import' => 'institutions#import'
  resources :institutions

  # get ':apikey/get/locations' => 'exporter#locations'

  #get 'institutions/:id/edit' => 'institution#edit'


# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".

# You can have the root of your site routed with "root"
# root 'welcome#index'

# Example of regular route:
#   get 'products/:id' => 'catalog#view'

# Example of named route that can be invoked with purchase_url(id: product.id)
#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

# Example resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Example resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Example resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end

# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
end

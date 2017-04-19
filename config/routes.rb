Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root 'welcome#index'
      get 'doc' => 'welcome#doc'
      get ':apikey/get/ssids' => 'ssids#get'
      get ':apikey/get/locations' => 'locations#get'
      get ':apikey/set/:address/:identifier/:city/:ap' => 'entries#set'
      get ':apikey/set/:address/:identifier/:city/:ap/:ssid' => 'entries#set'
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

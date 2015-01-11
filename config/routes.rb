Rails.application.routes.draw do


  # OmniAuth for provider
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/sessions/google/new', to: 'sessions#new_google_auth'
  
  # Static Pages
  get '/about', to: 'welcome#about'
  
  # Aliases
  get '/account', to: 'users#index'
  
  namespace :admin do
    resources :surveys
    resources :users
  end

  resources :users 
  
  resources :surveys do
    resources :editors do
      member do
        get 'invite'
        put 'accept'
      end
    end
    resources :invites
    resources :survey_items
    resources :responses do
      member do
        get 'thanks'
      end
      resources :item_ranks
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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

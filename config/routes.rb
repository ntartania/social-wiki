Rails.application.routes.draw do
  
  get 'subject/index'

  resources :posts do
    member do 
      post 'vote', to: 'posts#vote'
    end
    resources :comments
  end
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :subjects
  
  resources :users

  root 'sessions#home'

  get 'pages/home'

  get 'login' => 'sessions#login' 

  post 'login' => 'sessions#login_attempt'

  get 'logout' => 'sessions#logout'

  get 'home' => 'sessions#home'

  get 'profile' => 'sessions#profile'

  get 'setting' => 'sessions#setting'

  get 'signup' => 'users#signup'

  get 'subjects' => 'subjects#index'
  
  get 'users' => 'users#index'

  get 'feed' => 'sessions#feed'

  get 'following' => 'users#following'

  get 'followers' => 'users#followers'

  resources :relationships,       only: [:create, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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

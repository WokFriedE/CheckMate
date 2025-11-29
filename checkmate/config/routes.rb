Rails.application.routes.draw do
  resources :messages
  resources :returns
  resources :orders
  resources :inventories, only: %i[index new create]
  resources :checkout

  root 'application#index'

  get  'signup', to: 'authentication#signup_form'
  post 'signup', to: 'authentication#signup'

  get  'login', to: 'authentication#login_form'
  post 'login', to: 'authentication#login'

  delete 'logout', to: 'authentication#logout'

  get 'landing', to: 'landing#index'

  namespace :admin do
    resources :org_roles, only: %i[index new create]
    resources :organizations
  end

  # creates routes for /org/:org_id/*
  resources :organizations, path: 'org', param: :org_id do
    # creates routes for /org/:org_id/inventory
    resources :item_details, path: 'inventory', controller: 'dashboard/item_details',
                             only: %i[index show new create destroy]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end

# Note you can use `rails routes` to get route prefixes and add _path to the prefix for a fast prefix

Rails.application.routes.draw do
  devise_for :users

  post 'charges/switch_to_premium'
  post 'charges/switch_to_basic'
  get 'charges/change_subscription'
  resources :wikis

  root 'welcome#index'

  get 'welcome/about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

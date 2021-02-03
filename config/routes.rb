Rails.application.routes.draw do
  root to: 'users#index'

  resources :users
  resources :goals
  resource :session, only: [:new, :create, :destroy]
end

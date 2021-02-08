Rails.application.routes.draw do
  root to: 'users#index'

  resources :users, only: [:index, :show, :new, :create]
  resources :goals
  resource :session, only: [:new, :create, :destroy]
end

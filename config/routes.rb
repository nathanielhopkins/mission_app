Rails.application.routes.draw do
  root to: 'users#index'

  resources :users do
    resources :goals, only: [:new]
  end
  resources :goals, except: [:new, :index]
  resource :session, only: [:new, :create, :destroy]
end

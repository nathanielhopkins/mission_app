Rails.application.routes.draw do
  resources :user
  resource :session, only: [:new, :create, :destroy]
end

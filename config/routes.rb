Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #resources :clients
  root "index#index"


  resources :clients, :controller => :index
  resources :reservations, :controller => :index
  resources :rooms
  get 'standart', to: :standart, controller: 'rooms'
  get 'luxe', to: :standart, controller: 'rooms'

  post 'choose_date_post', to: :choose_date_post, controller: 'index'

  get 'choose_date', to: :choose_date, controller: 'index'
  get 'succeed', to: :succeed, controller: 'index'
end

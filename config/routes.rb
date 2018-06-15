Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #resources :clients
  root "book#index"


  resources :clients, :controller => :book
  resources :reservations, :controller => :book
  resources :rooms
  get 'standart', to: :standart, controller: 'rooms'
  get 'luxe', to: :standart, controller: 'rooms'

  get 'choose_date', to: :choose_date, controller: 'book'
  post 'choose_date_post', to: :choose_date_post, controller: 'book'

  get 'payment', to: :payment, controller: 'book'
  post 'payment_post', to: :payment_post, controller: 'book'
  #patch 'payment_post', to: :payment_post, controller: 'book'

  get 'choose_payment', to: :choose_payment, controller: 'book'
  post 'choose_payment_post', to: :choose_payment_post, controller: 'book'
  patch 'choose_payment_post', to: :choose_payment_post, controller: 'book'

  get 'prepayment', to: :prepayment, controller: 'book'
  post 'prepayment_post', to: :prepayment_post, controller: 'book'

  get 'succeed', to: :succeed, controller: 'book'
end

Rails.application.routes.draw do
  mount Tolk::Engine => '/y', :as => 'tolk'
  devise_for :admin_users, ActiveAdmin::Devise.config
  # scope ':locale', defaults: { locale: I18n.locale } do
  #   ActiveAdmin.routes(self)
  # end
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #resources :clients
  root "book#index"


  resources :clients, :controller => :book
  resources :reservations, only: [ :index, :create, :update ], :controller => :book
  resources :rooms
  get 'standart', to: :standart, controller: 'rooms'
  get 'luxe', to: :standart, controller: 'rooms'
  get 'payment', to: :payment, controller: 'book'
  post 'payment', to: :payment, controller: 'book'

  resources :about_us
  resources :gallery
  resources :prices
  resources :contact
end

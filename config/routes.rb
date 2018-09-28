Rails.application.routes.draw do
  mount Tolk::Engine => '/y', :as => 'tolk'
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root "book#index"

  resources :clients, :controller => :book
  resources :reservations, only: [ :index, :create, :update ], :controller => :book
  resources :rooms
  Room.all.each do |room|
    get room.name, to: :"#{room.name}", controller: 'rooms'
  end
  post 'payment', to: :payment, controller: 'book'

  resources :gallery
  resources :prices
  resources :contact
end

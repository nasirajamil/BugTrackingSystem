Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations"}
  get 'home/homepage', to: 'home#homepage'
  root 'home#homepage'
  get 'project/new', to: 'project#new'
  #post 'project/new'
  resources :project
end

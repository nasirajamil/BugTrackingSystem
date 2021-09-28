Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations",omniauth_callbacks: 'users/omniauth_callbacks'}
  get 'home/error_page', to: 'home#error_page'

  devise_scope :user do
    authenticated :user do
      root 'devise/sessions#new', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end  

  resources :project do
    resources :bug
  end
  resources :tasks
  get 'project/new', to: 'project#new'
  post 'project/:id', to: 'project#show'
  post 'project/:id/edit', to: 'project#edit'
  patch 'project/:id', to: 'project#update'
  get 'menu', to: 'project#menu'
  get 'developer_menu', to: 'project#developer_menu'
  post 'add_user_to_project/:id', to: 'project#add_user_to_project'
  post 'change_status/:bug_id/:project_id', to: 'project#change_status'
  post 'assign_bug/:bug_id/:project_id', to: 'project#assign_bug'
  post 'remove_user_from_project/:Pid/:Uid', to: 'project#remove_user_from_project'
  get 'dashboard/:id', to: 'project#dashboard'
end

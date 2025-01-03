Rails.application.routes.draw do
  # Página inicial
  root "home#index"

  # Rotas do Devise (exceto recuperação de senha)
  devise_for :users, skip: [ :passwords ]

  # Rotas personalizadas para recuperação de senha
  get "recuperar-senha", to: "passwords#new", as: :new_password
  post "recuperar-senha", to: "passwords#create", as: :passwords
  get "recuperar-senha/:token", to: "passwords#edit", as: :edit_password
  patch "recuperar-senha/:token", to: "passwords#update", as: :password

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
  end

  # Rotas para tags
  resources :tags

  # Rotas para perfis
  scope "profiles" do
    get "/edit", to: "profiles#edit", as: :edit_profile
    get "/change_password", to: "profiles#edit_password", as: :edit_user_password
    patch "/update_password", to: "profiles#update_password", as: :update_user_password
    patch "/", to: "profiles#update", as: :update_profile
    get "/:username", to: "profiles#show", as: :profile
  end

  # Rotas para upload de arquivos
  resources :uploads, only: [ :new, :create ]

  # Rota do Sidekiq
  if Rails.env.development?
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end
end

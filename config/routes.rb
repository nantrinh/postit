Rails.application.routes.draw do
  root to: 'posts#index'
  resources :posts, :categories, except: :destroy do
    resources :comments, only: :create
  end

  resources :users, only: [:create, :show, :edit, :update]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
end

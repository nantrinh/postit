Rails.application.routes.draw do
  root to: 'posts#index'
  resources :posts, :categories, except: :destroy do
    resources :comments, only: :create
  end
end

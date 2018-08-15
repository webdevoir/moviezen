Rails.application.routes.draw do
  devise_for :users
  get 'movies/search'
  post 'movies/search_suggest'
  resources :movies, only: [:show] 
  resources :user_movies, only: [:show, :update]

  root 'static_pages#home'
end

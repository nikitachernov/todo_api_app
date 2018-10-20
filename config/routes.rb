Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :create, :update, :destroy]
      resources :tags, only: [:index, :create, :update, :destroy]
    end
  end
end

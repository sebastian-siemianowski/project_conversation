Rails.application.routes.draw do
  devise_for :users
  root "projects#index"

  resources :projects do
    resources :comments, only: [:create, :edit, :update, :destroy]
    member do
      patch :change_status
    end
  end
end


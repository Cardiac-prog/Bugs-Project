Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "projects#index"

  resources :projects
end

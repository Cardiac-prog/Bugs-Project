Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "projects#index"

  resources :projects do
    resources :bugs, only: [ :new, :create, :index, :show ]
  end
end

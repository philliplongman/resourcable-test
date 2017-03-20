Rails.application.routes.draw do
  resources :users do
    resource :profile
    resources :posts do
      resources :comments
    end
  end
end

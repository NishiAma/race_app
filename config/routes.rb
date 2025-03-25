Rails.application.routes.draw do
  root 'races#index'
  
  resources :races do
    resources :participants
  end
end 
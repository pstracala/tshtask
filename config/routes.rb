Tshtask::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users, except: [:show, :index]
  resources :money, except: [:delete, :edit, :update, :create, :new]
  post '/refresh_rates', to: 'money#refresh_rates'
end
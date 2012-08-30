SignManager::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  devise_for :users, :path_names => { :sign_in=>'login', :sign_out=>'logout' }

  resources :users, :except => [:new]
  resources :info, :only => [] do
    collection do
      get :performance
      get :configuration
      get :reload_configuration
    end
  end
  resources :slides
  resources :signs do
    resources :slots, :only => [:index, :edit, :destroy]
    member do
      get :info
      get :check_in
    end
  end
  resources :slots, :only => [:create, :update, :destroy] do
    collection do
      put :sort
      post :destroy_multiple
    end
  end
  resources :departments

  root :to=>"#{AppConfig.routing.default.controller}##{AppConfig.routing.default.action}"
end
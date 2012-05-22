SignManager::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  devise_for :users, :path_names => { :sign_in=>'login', :sign_out=>'logout' }

  resources :announcements
  resource :dashboards, :only => :show
  resources :documents

  resources :users, :except => [:new] do
    get :auto_update, :on => :member
  end
  resources :info, :only => [] do
    collection do
      get :performance
      get :database
      get :configuration
      get :reload_configuration
    end
  end
  resources :slides
  resources :signs do
    resources :slots, :only => [:index, :edit, :destroy]
    member do
      get :check_in
    end
  end
  resources :slots, :only => [:create, :update, :destroy] do
    put :sort, :on=>:collection
  end
  resources :departments

  root :to=>"#{AppConfig.routing.default.controller}##{AppConfig.routing.default.action}"
end
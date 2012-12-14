SignManager::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  resources :users, :except => [:new]
  resources :info, :only => [] do
    collection do
      get :configuration
      get :reload_configuration
    end
  end
  resources :slides
  resources :signs do
    resources :slots, :only => :edit
    member do
      get :info
      get :check_in
    end
  end
  resources :slots, :only => [:create, :update] do
    collection do
      put :sort
      post :destroy_multiple
    end
  end
  resources :departments

  # this is just a convenience to create a named route to rack-cas' logout
  match '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

  root :to=>"#{AppConfig.routing.default.controller}##{AppConfig.routing.default.action}"
end
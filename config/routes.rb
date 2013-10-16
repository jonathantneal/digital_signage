SignManager::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  resources :users, :except => [:new]
  resources :slides do
    collection do
      post :destroy_multiple
      put :update_multiple
      get :edit_multiple
      post :add_to_signs
    end
  end
  resources :signs do
    resources :slots, :only => :destroy
    member do
      get :info
      get :check_in
      get :display
      post :drop_on
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
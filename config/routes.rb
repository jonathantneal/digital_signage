SignManager::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  resources :users, except: [:new] do
    get :impersonate, on: :member
    get :stop_impersonating, on: :collection
  end
  resources :slides, except: [:new] do
    member do
      get :show_editable_content
      get :fork
    end
    collection do
      post :destroy_multiple
      put :update_multiple
      get :edit_multiple
      post :add_to_signs
      post :drop_create
    end
  end
  resources :signs, except: [:new] do
    resources :slots, only: :destroy
    member do
      get :check_in
      get :display
      post :drop_on
      put :sort
    end
  end
  resources :slots, only: [:create, :update] do
    collection do
      put :sort
      post :destroy_multiple
    end
  end
  resources :departments

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

  root to: "signs#index"
end
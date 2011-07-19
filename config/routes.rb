SignManager::Application.routes.draw do

  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do

    # The priority is based upon order of creation: first created -> highest priority.

    devise_for :users, :path_names => { :sign_in=>'login', :sign_out=>'logout' }

    resources :announcements
    resource :dashboards, :only => :show
    resources :documents

    resources :users, :except => [:new, :edit, :update] do
      get :auto_update, :on => :member
    end
    resources :info, :only => [] do
      collection do
        get :performance
        get :database
        get :configuration
        get :reload_configuration
        get :appinfo
      end
    end
    resources :slides
    resources :signs do
      resources :slots, :only => [:index, :destroy]
      get :check_in, :on => :member
    end
    resources :slots do
      put :sort, :on=>:collection
    end

    # Named routes
    match 'appinfo' => 'info#appinfo'

    root :to=>"#{AppConfig.routing.default.controller}##{AppConfig.routing.default.action}"

  end

end

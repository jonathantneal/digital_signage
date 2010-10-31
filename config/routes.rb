ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  map.devise_for :users, :path_names=>{ :sign_in=>'login', :sign_out=>'logout' }

  map.resources :announcements
  map.resource :dashboards, :only=>:show
  map.resources :documents
  map.resources :users, :except=>[:new, :edit, :update], :member=>{:auto_update=>:get}
  map.resources :info, :only=>[], :collection=>{:performance=>:get, :database=>:get, :config=>:get, :reload_config=>:get, :appinfo=>:get}
  map.resources :slides
  map.resources :signs, :has_many => :slots, :shallow => true, :member=>{:check_in=>:get}
  map.resources :slots, :collection=>{:sort=>:post}

  # Named routes
  map.connect 'appinfo', :controller=>:info, :action=>:appinfo

  map.root :controller => AppConfig.routing.default.controller, :action => AppConfig.routing.default.action

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end

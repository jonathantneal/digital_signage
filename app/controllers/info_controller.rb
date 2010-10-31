class InfoController < ApplicationController

  before_filter :authenticate_user!, :except=>[:appinfo]
  filter_access_to :performance, :database, :config, :reload_config

  ssl_required :config if AppConfig.security.https_available

  def performance
    if NewRelic::Control.instance.developer_mode?
      redirect_to :controller=>'newrelic'
    else
      redirect_to AppConfig.newrelic.link
    end
  end

  def database
    redirect_to :controller=>'admin_data'
  end

  def config
    @config = AppConfig.deep_to_h
  end

  def reload_config
    AppConfig.reload!
    flash[:notice] = 'Application configuration reloaded'
    redirect_to config_info_path
  end

  # used by other sites to detecmine if a user has access to this site
  def appinfo
  
    @appinfo = {}
    @appinfo[:name] = AppConfig.app.name
    @appinfo[:base_url] = Rails.configuration.action_controller.relative_url_root || '/'
    @appinfo[:login_required] = AppConfig.security.login.required
    if params[:netid]
      @appinfo[:can_access] = User.new(:username=>params[:netid]).can_login?
    end
    
    if params.has_key?(:json)
      render(:json=>{:result=>'success', :data=>@appinfo})
    end
    
  end

end

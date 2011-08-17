class InfoController < ApplicationController

  before_filter :authenticate_user!, :except=>[:appinfo]
  filter_access_to :performance, :database, :configuration, :reload_configuration

  ssl_required :config if AppConfig.security.https_available && defined? SslRequirement

  def performance
    if NewRelic::Control.instance.developer_mode?
      redirect_to AppConfig.newrelic.developer_link
    else
      redirect_to AppConfig.newrelic.link
    end
  end

  def database
    redirect_to admin_data_root_path
  end

  def configuration
    @configuration = AppConfig.deep_to_h
  end

  def reload_configuration
    AppConfig.reload!
    flash[:notice] = 'Application configuration reloaded'
    redirect_to configuration_info_index_path
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

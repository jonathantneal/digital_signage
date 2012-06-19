class InfoController < ApplicationController

  before_filter :authenticate_user!
  filter_access_to :performance, :configuration, :reload_configuration

  ssl_required :config if AppConfig.security.https_available && defined? SslRequirement

  def performance
    if NewRelic::Control.instance.developer_mode?
      redirect_to AppConfig.newrelic.developer_link
    else
      redirect_to AppConfig.newrelic.link
    end
  end

  def configuration
    @configuration = AppConfig.deep_to_h
  end

  def reload_configuration
    AppConfig.reload!
    flash[:notice] = 'Application configuration reloaded'
    redirect_to configuration_info_index_path
  end

end

class InfoController < ApplicationController
  filter_access_to :configuration, :reload_configuration
  ssl_required :config if AppConfig.security.https_available

  def configuration
    @configuration = AppConfig.deep_to_h
  end

  def reload_configuration
    AppConfig.reload!
    flash[:notice] = 'Application configuration reloaded'
    redirect_to configuration_info_index_path
  end
end
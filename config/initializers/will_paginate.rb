ActiveRecord::Base.instance_eval do
  def per_page
    AppConfig.ui.pagination.per_page
  end
end

AdminData.config do |config|
  config.is_allowed_to_view = lambda { |controller| controller.try(:current_user).try(:is_admin?) },
  config.is_allowed_to_update = lambda { |controller| controller.try(:current_user).try(:is_admin?) }
end

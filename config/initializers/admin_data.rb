AdminData::Config.set = {
  :is_allowed_to_view => lambda { |controller| controller.try(:current_user).try(:is_admin?) },
  :is_allowed_to_update => lambda { |controller| controller.try(:current_user).try(:is_admin?) }
}

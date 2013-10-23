ActionLinks.configure do |config|
  @bootstrap_action_classes = { :show => 'btn btn-default', :edit => 'btn btn-default', :destroy => 'btn btn-danger' }
  @bootstrap_action_icons = { :show => 'icon-eye-open', :edit => 'icon-pencil', :destroy => 'icon-trash' }
  @action_icons = { :show => 'eye-open', :edit => 'pencil', :destroy => 'trash' }
end
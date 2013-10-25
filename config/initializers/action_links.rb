ActionLinks.configure do |config|
  @bootstrap_action_classes = { :show => 'btn btn-default', :edit => 'btn btn-default', :destroy => 'btn btn-danger' }
  @bootstrap_action_icons = { :show => 'fa.fa-eye', :edit => 'fa.fa-pencil', :destroy => 'fa.fa-trash-o' }
  @action_icons = { :show => 'eye-open', :edit => 'pencil', :destroy => 'trash' }
end
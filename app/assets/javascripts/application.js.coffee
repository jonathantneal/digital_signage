#= require jquery
#= require jquery_ujs
#= require jquery_extensions
#
# Vendor Assets
#= require bootstrap
#= require colorpicker
#= require dropzone
#= require jquery.cycle
#= require slideshow.min
#=  require redactor
#
#= require_self
#= require_tree ./shared
#= require_tree ./resources



if $('#filter_wrapper').length > 0

  resetContentHeight = ->
    margin = $('#filter_wrapper').outerHeight() + $('#top_navbar').outerHeight()
    $('body').css('margin-top', margin)

    $('#filter_wrapper').css('top', $('#top_navbar').outerHeight())


  # TODO: You will also need to run this on window resize
  resetContentHeight()




# for rendering flash messages in javascript responses
window.flashMessages = (messages) ->
  for message in messages
    alert_class = 'alert alert-' + alertClass(message[0])
    new_message = $("<div class=\"message #{alert_class}\"><a class=\"close\" data-dismiss=\"alert\" href=\"#\">&times;</a> #{message[1]} </div>")

    $("#floating_messages").append(new_message)

    # Automaticaly close message after 2 seconds
    setTimeout (-> new_message.alert('close')), 5000


alertClass = (type) ->
  switch type
    when 'notice' then 'info'
    when 'error' then 'danger'
    else type
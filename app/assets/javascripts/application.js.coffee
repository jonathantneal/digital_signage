#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require jquery_extensions
#
# Vendor Assets
#= require bootstrap
#= require colorpicker
#= require dropzone
#= require jquery.cycle
#= require slideshow.min
#
#= require_self
#= require_tree ./resources



if $('#filter_wrapper').length > 0

  resetContentHeight = ->
    margin = $('#filter_wrapper').outerHeight() + $('#top_navbar').outerHeight() + 20
    $('body').css('margin-top', margin)

    $('#filter_wrapper').css('top', $('#top_navbar').outerHeight())


  # TODO: You will also need to run this on window resize
  resetContentHeight()
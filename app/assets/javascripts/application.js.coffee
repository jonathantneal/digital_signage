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
    margin = $('#filter_wrapper').outerHeight() + $('#top_navbar').outerHeight()
    $('body').css('margin-top', margin)

    $('#filter_wrapper').css('top', $('#top_navbar').outerHeight())


  # TODO: You will also need to run this on window resize
  resetContentHeight()


if $('#slide-upload-dropzone').length > 0
  Dropzone.options.slideUploadDropzone = {
    clickable: false
    createImageThumbnails: false
    dictDefaultMessage: "Drag and drop files to upload"

    addedfile: ->
      $('#page-spinner').show()
    processing: ->
      # wait for it...
    uploadprogress: ->
      # wait for it......
    success: ->
      # It takes a second for the image to process. So just wait here for a second before reloading
      setTimeout((-> location.reload()), 1000)
  }
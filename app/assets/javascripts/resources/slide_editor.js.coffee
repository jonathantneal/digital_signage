if ($('body.slides.show').length > 0) && ($('#editable_content').length > 0)

  ###
    Handle resizing editor frame to match the display size
  ###
  resizeEditor = ->
    display_width  = 1920
    display_height = 1080
    container_width = $('#slide_preview').width()
    zoom_factor = container_width / display_width

    editor = $('#slide_preview .slide_preview')

    # should only do this once on load
    editor.width(display_width)
    editor.height(display_height)

    # should do this every time screen resizes
    editor.css('zoom', zoom_factor)

  resizeEditor()

  $(window).resize ->
    resizeEditor()

$(document).ready ->
  if $('body.slides.show').length > 0


    # Initialize color picker
    colorize = [
      control: '#slide_background_color'
      target: '#background_color_target'
    ,
      control: '#slide_overlay_color'
      target: '#editor_container'
    ]
    $.each colorize, (index, options) ->
      $(options.control).colorpicker({format: 'rgba'}).on 'changeColor', (ev) ->
        $(options.target).css 'background-color', ev.color.toRGBstring()




  if $('#editable_content').length > 0


    ###
      Handle resizing editor frame to match the display size
    ###
    resizeEditor = ->
      display_width  = 1920
      display_height = 1080
      container_width = $('#slide_preview').width()
      zoom_factor = container_width / display_width

      editor = $('#editor_container')

      # should only do this once on load
      editor.width(display_width)
      editor.height(display_height)

      # should do this every time screen resizes
      editor.css('zoom', zoom_factor)

    resizeEditor()

    $(window).resize ->
      resizeEditor()

$(document).ready ->

  if $('body.signs.index').exists()
    $(".sign_slides").slides
      play: 5000
      pagination: false
      generatePagination: false
      effect: 'fade'

  if $('body.signs.show').exists()

    # window.refresh_preview_size = ->
    #   $("ol.slots li div.thumbnail").css "width", (localStorage.slidervalue or 336)
    #   $("ol.slots li div.thumbnail").css "height", ($("ol.slots li div.thumbnail").width() * 113 / 200.0)
    #   $("ol.slots li div.thumbnail").css "line-height", ($("ol.slots li div.thumbnail").width() * 113 / 200.0 - 3)+"px"

    # $("#thumb_size_slider").slider
    #   value: (localStorage.slidervalue or 336)
    #   min: 175
    #   max: 336
    #   step: 1
    #   slide: (event, ui) ->
    #     $("ol.slots li div.thumbnail").css "width", ui.value
    #     $("ol.slots li div.thumbnail").css "height", (ui.value * 113 / 200.0)
    #     $("ol.slots li div.thumbnail").css "line-height", (ui.value * 113 / 200.0 - 3)+"px"

    #   change: (event, ui) ->
    #     localStorage.slidervalue = ui.value

    # # Initiate width when page loads
    # refresh_preview_size()

    $('.remove_slide_link').click ->
      $(this).parents('li.slot').remove()

    $("ol.slots").sortable
      items: ".slot"
      containment: "parent"
      start: (e, info) ->
        info.item.siblings(".selected").not(".ui-sortable-placeholder").appendTo info.item

      stop: (e, info) ->
        info.item.after info.item.find("li")

      update: ->
        $.ajax
          type: "PUT"
          url: ROOT_URL + "slots/sort"
          data: $(this).sortable("serialize")
          dataType: "script"
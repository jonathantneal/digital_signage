$(document).ready ->

  if $('body.signs.index').exists()
    $(".sign_slides").slides
      play: 5000
      pagination: false
      generatePagination: false
      effect: 'fade'

  if $('body.signs.show').exists()

    window.refresh_preview_size = ->
      $("ol.slots li div.thumbnail").css "width", (localStorage.slidervalue or 336)
      $("ol.slots li div.thumbnail").css "height", ($("ol.slots li div.thumbnail").width() * 113 / 200.0)

    removeSlots = (slots) ->
      r = confirm("Are you sure you would like to remove these " + slots.length + " slides from this sign?")
      return  unless r
      str = []
      $(slots).each ->
        res = $(this).attr("id").match(/(.+)[-=_](.+)/)
        str.push (res[1] + "[]") + "=" + (res[2])  if res

      str = str.join("&")
      $.ajax
        type: "POST"
        url: ROOT_URL + "slots/destroy_multiple"
        data: str
        dataType: "script"
        success: (data) ->
          slots.remove()

    $("#show-slide-button").click (e) ->
      window.location = ($("ol.slots li.selected").first().data("show-url"))
      e.stopPropagation()

    $("#edit-slide-button").click (e) ->
      window.location = ($("ol.slots li.selected").first().data("edit-url"))
      e.stopPropagation()

    $("#remove-slide-button").click (e) ->
      removeSlots $("ol.slots li.selected")
      e.stopPropagation()

    $("#slide_options .google_button").hide()
    $("#thumb_size_slider").slider
      value: (localStorage.slidervalue or 336)
      min: 175
      max: 336
      step: 1
      slide: (event, ui) ->
        $("ol.slots li div.thumbnail").css "width", ui.value
        $("ol.slots li div.thumbnail").css "height", (ui.value * 113 / 200.0)

      change: (event, ui) ->
        localStorage.slidervalue = ui.value

    
    # Initiate width when page loads
    refresh_preview_size()

    $("ol.slots li").live "click", (e) ->
      if not event.altKey and not event.shiftKey
        $(".selected").not(this).removeClass "selected"
      else if event.shiftKey
        last_selected = $(".last_selected").index()
        this_index = $(this).index()
        if last_selected < this_index
          $("ol.slots li").slice(last_selected, this_index).addClass "selected"
        else $("ol.slots li").slice(this_index + 1, last_selected).addClass "selected"  if last_selected > this_index
      $(this).toggleClass "selected"
      $(".last_selected").removeClass "last_selected"
      $(this).addClass "last_selected"

      if $("ol.slots li.selected").length > 1
        $(".single_slide_button").hide()
      else if $("ol.slots li.selected").length is 1
        $("#slide_options .google_button").show()
      else
        $("#slide_options .google_button").hide()
      e.stopPropagation()

    $("body").live "click", (e) ->
      $(".selected").removeClass "selected"
      $("#slide_options .google_button").hide()

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



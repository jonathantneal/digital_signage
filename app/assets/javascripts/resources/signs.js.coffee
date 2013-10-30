$(document).ready ->

  if $('body.signs.index').exists()
    $(".sign_slides").slides
      play: 5000
      pagination: false
      generatePagination: false
      effect: 'fade'

  if $('body.signs.show').exists()

    $('.link.remove_slide').click ->
      $(this).parents('li.slot').remove()

    $('ol.slots.sortable').sortable
      items: ".slot"
      containment: "parent"
      start: (e, info) ->
        info.item.siblings(".selected").not(".ui-sortable-placeholder").appendTo info.item

      stop: (e, info) ->
        info.item.after info.item.find("li")

      update: ->
        $.ajax
          type: "PUT"
          # url: ROOT_URL + "slots/sort"
          url: (location.protocol + '//' + location.host + location.pathname).replace(/\/$/, '') + "/sort"
          data: $(this).sortable("serialize")
          dataType: "script"
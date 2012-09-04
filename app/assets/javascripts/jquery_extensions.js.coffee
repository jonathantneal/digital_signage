jQuery.fn.observe = (time, callback) ->

  @each ->

    form = @
    change = false

    $(form.elements).bind 'keyup change', ->
      form = $ form
      if form.data('serialized') != form.serialize()
        form.data 'serialized', form.serialize()
        change = true

    setInterval ->
      callback.call form if change
      change = false
    , time * 1000


jQuery.getStylesheet = (url) ->
  $('<link>').attr
    rel: 'stylesheet'
    type: 'text/css'
    href: url
  .appendTo 'head'


jQuery.fn.exists = ->
  jQuery(this).length > 0

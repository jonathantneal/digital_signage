#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require jquery_extensions
#= require_self
#= require_tree ./plugins
#= require_tree ./resources


collapseSidebarBoxes = (boxes) ->
  $.each boxes, (i, box) ->
    box = $(box)
    title = box.find("h3")
    title.css cursor: "pointer"
    unless box.hasClass("opened")
      
      # If the title is a link don't open, just follow the link
      unless title.children("a").length
        box.open = ->
          box = $(this).closest(".box")
          box.animate
            width: box.data("open").w
            height: box.data("open").h
          , "fast"

        box.close = ->
          box = $(this).closest(".box")
          box.animate
            width: box.data("closed").w
            height: box.data("closed").h
          , "fast"

        title.bind "click", box.open
        box.append $("<a></a>").addClass("cancel").attr("href", "#").html("Cancel").click(box.close)
      box.data "open",
        w: box.width() + "px"
        h: box.height() + "px"

      box.data "closed",
        w: 200
        h: title.height() + "px"

      box.css
        position: "relative"
        overflow: "hidden"
        width: box.data("closed").w
        height: box.data("closed").h


ajaxifySearchForm = (form) ->
  form = $(form)
  form.find("input[type=submit]").hide()
  form.observe 2, ->
    form.data "serialized", form.serialize()
    form.addClass "searching"
    $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script
    $.ajax
      url: form.attr("action")
      data: form.serialize()
      dataType: "html"
      success: (data) ->
        form.removeClass "searching"
        $(".search_results").html data
        refresh_preview_size() if typeof window.refresh_preview_size is "function"


flashMessages = (messages) ->
  $("#messagesWrapper").html "<ul id=\"messages\"/>"  unless $("#messages").length
  for key of messages
    $("#messages").append "<li class=\"" + key + "\">" + messages[key] + "</li>"


$(document).ready ->
  collapseSidebarBoxes $("#contentAside .box")
  $("form.search, form.filter").each ->
    ajaxifySearchForm this


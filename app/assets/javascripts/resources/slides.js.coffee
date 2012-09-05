$(document).ready ->

  if $('body.slides').exists()
    
    @add_fields = (link, association, content) ->
      new_id = new Date().getTime()
      regexp = new RegExp("new_" + association, "g")
      $("#" + association).append content.replace(regexp, new_id)

    # Date Picker
    $(".publish_at input[type=text]").datepicker dateFormat: "MM d, yy '12:00 AM'"
    $(".unpublish_at input[type=text]").datepicker dateFormat: "MM d, yy '11:59 PM'"
    
    # Color Picker
    colorBox = $("dd.color input")
    if typeof (jQuery.fn.ColorPicker) isnt "undefined" and colorBox.length
      colorBox.ColorPicker
        color: colorBox.val()
        onShow: (colpkr) ->
          $(colpkr).fadeIn 500
          false

        onHide: (colpkr) ->
          $(colpkr).fadeOut 500
          false

        onChange: (hsb, hex, rgb) ->
          colorBox.val hex
          colorBox.css
            color: "#" + hex
            backgroundColor: "#" + hex


    $("input.delete[type=checkbox]").live "click", (event) ->
      $(this).closest("li,tr").fadeOut()


  if $('body.slides.index').exists()
    window.refresh_preview_size = ->
      $("ul.slides li div.thumbnail").css "width", (localStorage.slidervalue or 336)
      $("ul.slides li div.thumbnail").css "height", ($("ul.slides li div.thumbnail").width() * 113 / 200)

    if $('.pagination').length
      $(window).scroll ->
        url = $('.pagination .next').attr('href')
        if url && $(window).scrollTop() > $(document).height() - $(window).height() - 350
          $('.pagination').text("Fetching more slides...")
          $.getScript(url).done (script, textStatus) ->
            refresh_preview_size()
      $(window).scroll()


    $("#thumb_size_slider").slider
      value: (localStorage.slidervalue or 336)
      min: 175
      max: 336
      step: 1
      slide: (event, ui) ->
        $("ul.slides li div.thumbnail").css "width", ui.value
        $("ul.slides li div.thumbnail").css "height", (ui.value * 113 / 200.0)
      change: (event, ui) ->
        localStorage.slidervalue = ui.value
    # Initiate width when page loads
    refresh_preview_size()

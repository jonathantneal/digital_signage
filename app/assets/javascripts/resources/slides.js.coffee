$(document).ready ->

  if $('body.slides').exists()
    
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

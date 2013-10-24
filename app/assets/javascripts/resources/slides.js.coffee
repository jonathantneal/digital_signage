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


    $(document).on "click", "input.delete[type=checkbox]", (event) ->
      $(this).closest("li,tr").fadeOut()


  if $('body.slides.index').exists()
    # window.refresh_preview_size = ->
    #   $("ul.slides li div.thumbnail").css "width", (localStorage.slidervalue or 336)
    #   $("ul.slides li div.thumbnail").css "height", ($("ul.slides li div.thumbnail").width() * 113 / 200)
    #   $("ul.slides li div.thumbnail").css "line-height", ($("ul.slides li div.thumbnail").width() * 113 / 200 - 3)+"px"

    refresh_endless_scroll = ->
      if $('.pagination').length
        $(window).scroll ->
          url = $('.pagination .next').attr('href')
          if url && $(window).scrollTop() > $(document).height() - $(window).height() - 350
            $('.pagination').text("Fetching more slides...")
            $.getScript(url).done (script, textStatus) ->
              # refresh_preview_size()
        $(window).scroll()

    refresh_endless_scroll()
    # You have to run this again when ajax completes in case the filter parameters have changes.
    $(document).ajaxComplete ->
      refresh_endless_scroll()



    # $("#thumb_size_slider").slider
    #   value: (localStorage.slidervalue or 336)
    #   min: 175
    #   max: 336
    #   step: 1
    #   slide: (event, ui) ->
    #     $("ul.slides li div.thumbnail").css "width", ui.value
    #     $("ul.slides li div.thumbnail").css "height", (ui.value * 113 / 200.0)
    #     $("ul.slides li div.thumbnail").css "line-height", (ui.value * 113 / 200.0 - 3)+"px"
    #   change: (event, ui) ->
    #     localStorage.slidervalue = ui.value
    # # Initiate width when page loads
    # refresh_preview_size()

    # ****  Enable Multi Select  ******    TODO, you may want to break this off into a jQuery plugin eventually
    $(document).on "click", "ul.slides li", (e) ->
      if not e.altKey and not e.shiftKey
        $(".selected").not(this).removeClass "selected"
      else if e.shiftKey
        last_selected = $(".last_selected").index()
        this_index = $(this).index()
        if last_selected < this_index
          $("ul.slides li").slice(last_selected, this_index).addClass "selected"
        else $("ul.slides li").slice(this_index + 1, last_selected).addClass "selected"  if last_selected > this_index
      $(this).toggleClass "selected"
      $(".last_selected").removeClass "last_selected"
      $(this).addClass "last_selected"

      if $("ul.slides li.selected").length > 1
        $(".single_slide_button").hide()
      else if $("ul.slides li.selected").length is 1
        $("#slide_options .btn").show()
      else
        $("#slide_options .btn").hide()
      e.stopPropagation()


    # ***** Enable context sensitive buttons based on what slide is currently selected  ********
    $(document).on "click", "body", (e) ->
      unless $(this).hasClass('modal-open')
        $(".selected").removeClass "selected"
        $("#slide_options .btn").hide()

    $("#add-to-sign-button").click (e) ->
      selected_slides = $("ul.slides li.selected")
      addSlidesToSign selected_slides
      e.stopPropagation()

    $("#edit-slide-button").click (e) ->
      selected_slides = $("ul.slides li.selected")
      if selected_slides.length == 1
        window.location = (selected_slides.first().data("edit-url"))
      if selected_slides.length > 1
        editSlides selected_slides
      e.stopPropagation()

    $("#remove-slide-button").click (e) ->
      removeSlides $("ul.slides li.selected")
      e.stopPropagation()

    $("#slide_options .btn").hide()  # hide all the option buttons on page load


    # *****  Remove slides or multiple selected slides at the same time  ******
    removeSlides = (slides) ->
      r = confirm("Are you sure you would like to delete these " + slides.length + " slides? This action is irreversible.")
      return  unless r

      # Serialize slide id's
      str = []
      $(slides).each ->
        if slide_id = $(this).data("slide-id")
          str.push "slide[]="+slide_id
      str = str.join("&")

      # Delete slides via AJAX and then remove them from the DOM on success
      $.ajax
        type: "POST"
        url: ROOT_URL + "slides/destroy_multiple"
        data: str
        dataType: "script"
        success: (data) ->
          slides.remove()

    # ****** Edit multiple slides  *****
    editSlides = (slides) ->
      # Serialize the selected slide ids and pass them as parameters to slides#edit_multiple
      slide_array = $.map slides, (slide) ->
        $(slide).data("slide-id")
      window.location = ROOT_URL + "slides/edit_multiple?" + $.param({s_ids:slide_array})


    # ****** Add one or more slides to a sign  *****
    addSlidesToSign = (slides) ->
      slide_array = $.map slides, (slide) ->
        $(slide).data("slide-id")
      $('#slide_ids').val slide_array
      openSignSelectModal()

    openSignSelectModal = ->
      $('#signSelectModal').modal('show')







  #########  Shared Javascript

  if $('#new_slide_mini_form').length > 0
    # ***** Toggle between new slide options ********
    refreshNewSlideOptions = (toggles) ->
      option = toggles.find(':checked').data('option')
      $('.content_options').hide()
      $(option).show()
    $('#slide_option_buttons').change ->
      refreshNewSlideOptions($(this))
    refreshNewSlideOptions($('#slide_option_buttons'))
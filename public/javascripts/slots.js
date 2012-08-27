$(document).ready(function() {

  function removeSlots(slots) {
    var r=confirm("Are you sure you would like to remove these "+slots.length+" slides from this sign?");
    if (!r) return;


    var str = []
    $(slots).each(function() {
      var res = $(this).attr('id').match(/(.+)[-=_](.+)/);
      if(res) str.push((res[1]+'[]')+'='+(res[2]));
    });
    str = str.join('&');
    $.ajax({
      type: 'POST',
      url: ROOT_URL+'/slots/destroy_multiple',
      data: str,
      dataType: 'script',
      success: function(data) {
        slots.remove();
      }
    });
  }

  $('#show-slide-button').click(function(e){
    window.location = ($('ol.slots li.selected').first().data('show-url'));
    e.stopPropagation();
  })
  $('#edit-slide-button').click(function(e){
    window.location = ($('ol.slots li.selected').first().data('edit-url'));
    e.stopPropagation();
  })
  $('#remove-slide-button').click(function(e){
    removeSlots($('ol.slots li.selected'));
    e.stopPropagation();
  });

  $('#slide_options .google_button').hide();
  $( "#thumb_size_slider" ).slider({
    value:  (localStorage.slidervalue || 336),
    min:    175,
    max:    336,
    step:   1,
    slide: function( event, ui ) {
      $( "ol.slots li div.thumbnail" ).css( "width", ui.value );
    },
    change: function ( event, ui ) {
      localStorage.slidervalue = ui.value
    }
  });
  // Initiate width when page loads
  $( "ol.slots li div.thumbnail" ).css( "width", (localStorage.slidervalue || 336));

  $('ol.slots li').click(function(e) {
    if(!event.altKey && !event.shiftKey) {
      $('.selected').not(this).removeClass("selected");
    } else if (event.shiftKey) {
      var last_selected = $('.last_selected').index();
      var this_index = $(this).index();
      if (last_selected < this_index)
        $('ol.slots li').slice(last_selected, this_index).addClass("selected");
      else if (last_selected > this_index)
        $('ol.slots li').slice(this_index+1, last_selected).addClass("selected");
    }

    $(this).toggleClass("selected");

    $('.last_selected').removeClass("last_selected");
    $(this).addClass("last_selected");

    if ($('ol.slots li.selected').length > 1) {
      $('.single_slide_button').hide();
    } else if ($('ol.slots li.selected').length == 1) {
      $('#slide_options .google_button').show();
    } else {
      $('#slide_options .google_button').hide();
    }

    e.stopPropagation();
  });
  $('body').click(function() {
    $('.selected').removeClass("selected");
    $('#slide_options .google_button').hide();
  });

  $('ol.slots').sortable({
    items:'.slot',
    containment: 'parent',
    start: function(e, info) {
        info.item.siblings(".selected").not(".ui-sortable-placeholder").appendTo(info.item);
    },
    stop: function(e, info) {
        info.item.after(info.item.find("li"));
    },
    update: function() {
      $.ajax({
        type: 'PUT',
        url: ROOT_URL+'/slots/sort',
        data: $(this).sortable('serialize'),
        dataType: 'script'
      });
    }
  });

})

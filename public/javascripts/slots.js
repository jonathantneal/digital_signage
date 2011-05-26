$(document).ready(function() {

  $('ol.slots').sortable({
    items:'.slot',
    containment: 'parent',
    axis:'y',
    update: function() {
      $.ajax({
        type: 'PUT',
        url: ROOT_URL+'slots/sort',
        data: $(this).sortable('serialize'),
        dataType: 'script'
      });
    }
  });

})

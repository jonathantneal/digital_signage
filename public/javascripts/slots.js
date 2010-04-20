$(document).ready(function() {

  $('ol.slots').sortable({
    items:'.slot',
    containment: 'parent',
    axis:'y',
    update: function() {
      $.post('../../slots/sort', $(this).sortable('serialize'));
    }
  });

})

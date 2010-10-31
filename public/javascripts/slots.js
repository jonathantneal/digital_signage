$(document).ready(function() {

  $('ol.slots').sortable({
    items:'.slot',
    containment: 'parent',
    axis:'y',
    update: function() {
      $.post(ROOT_URL+'slots/sort', $(this).sortable('serialize'));
    }
  });

})

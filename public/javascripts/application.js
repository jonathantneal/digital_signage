function collapseSidebarBoxes(boxes) {

 $.each(boxes, function(i, box) {

  box = $(box)
  var title = box.find('h3');

  title.css({cursor: 'pointer'});

  box.open = function() {
   box = $(this).closest('.box');
   box.animate({ width: box.data('open').w, height: box.data('open').h }, 'fast');
  }

  box.close = function() {
   box = $(this).closest('.box');
   box.animate({ width: box.data('closed').w, height: box.data('closed').h }, 'fast');
  }
 
  title.bind('click', box.open);
 
  box.append($('<a></a>').addClass('cancel').attr('href','#').html('Cancel').click(box.close));

  box.data('open', {w: box.width()+'px', h: box.height()+'px'});
  box.data('closed', {w: 200, h: title.height()+'px'});

  box.css({
   position: 'relative',
   overflow: 'hidden',
   width: box.data('closed').w,
   height: box.data('closed').h
  });
  
 });

}

function add_fields(link, association, content) {

 var new_id = new Date().getTime();
 var regexp = new RegExp('new_' + association, 'g')
 $('#'+association).append(content.replace(regexp, new_id));
 
}

$(document).ready(function() {
 
 collapseSidebarBoxes($('#contentExtra .box'));
 
});

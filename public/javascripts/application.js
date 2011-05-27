$.fn.observe = function( time, callback ){

 return this.each(function(){
 
  var form = this, change = false;
  
  $(form.elements).bind('keyup change', function(){
   form = $(form);
   if(form.data('serialized') != form.serialize()) {
    form.data('serialized', form.serialize());
    change = true;
   }
  });

  setInterval(function(){
   if ( change ) callback.call( form );
   change = false;
  }, time * 1000);
  
 });
 
};

function collapseSidebarBoxes(boxes) {

 $.each(boxes, function(i, box) {

  box = $(box)
  var title = box.find('h3');

  title.css({cursor: 'pointer'});

  if(!box.hasClass('opened')) {

   // If the title is a link don't open, just follow the link
   if(!title.children('a').length) {

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

   }

   box.data('open', {w: box.width()+'px', h: box.height()+'px'});
   box.data('closed', {w: 200, h: title.height()+'px'});

   box.css({
    position: 'relative',
    overflow: 'hidden',
    width: box.data('closed').w,
    height: box.data('closed').h
   });
  
  }
  
 });

}

function ajaxifySearchForm(form) {

 form = $(form);
 form.find('input[type=submit]').hide();
 form.observe(2, function() {

  form.data('serialized', form.serialize());
  form.addClass('searching');
  
  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
  $.ajax({
   url: form.attr('action'),
   data: form.serialize(),
   dataType: 'html',
   success: function(data) {
    form.removeClass('searching');
    $('.search_results').html(data);
   }
  });
 
 });

}

function flashMessages(messages) {
  if(!$('#messages').length) {
    $('#messagesWrapper').html('<ul id="messages"/>');
  }
  for(var key in messages) {
    $('#messages').append('<li class="'+key+'">'+messages[key]+'</li>');
  }
}

function add_fields(link, association, content) {

 var new_id = new Date().getTime();
 var regexp = new RegExp('new_' + association, 'g')
 $('#'+association).append(content.replace(regexp, new_id));
 
}

$(document).ready(function() {
 
 collapseSidebarBoxes($('#contentAside .box'));
 
 $('form.search, form.filter').each(function() { ajaxifySearchForm(this); });
 
});

$(document).ready(function() {
  var content = $('dd.content textarea');
  if(content.length) { content.wysiwyg({css: ROOT_URL+'/stylesheets/wysiwyg.css'}); }
});

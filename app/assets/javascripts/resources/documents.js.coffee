$(document).ready ->
  if $('body.documents').exists()
    content = $("dd.content textarea")
    content.wysiwyg css: ROOT_URL + "/stylesheets/wysiwyg.css"  if content.length
$(document).ready ->
  if $('body.announcements').exists()
    datepickers = $("dd.show_at input[type=text]")
    datepickers.datepicker dateFormat: "MM d, yy '12:00 AM'"  if datepickers.length
    announcement = $("dd.announcement textarea")
    announcement.wysiwyg css: ROOT_URL + "/stylesheets/wysiwyg.css"  if announcement.length


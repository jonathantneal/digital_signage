$(document).ready(function() {
  $('#page_login input[type=text], #page_login input[type=password]').each(function(i, input) {
    if(input.value == '') {
      input.focus();
      return false; // break
    }
  });
});

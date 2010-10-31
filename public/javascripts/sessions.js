$(document).ready(function() {
  $('#content input[type=text], #content input[type=password]').each(function(i, input) {
    if(input.value == '') {
      input.focus();
      return false; // break
    }
  });
});

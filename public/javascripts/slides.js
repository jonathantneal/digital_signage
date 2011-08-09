$(document).ready(function() {

  // Color Picker
  var colorBox = $('dd.color input');
  if(typeof(jQuery.fn.ColorPicker) != 'undefined' && colorBox.length) {
    colorBox.ColorPicker({
	    color: colorBox.val(),
	    onShow: function (colpkr) {
		    $(colpkr).fadeIn(500);
		    return false;
	    },
	    onHide: function (colpkr) {
		    $(colpkr).fadeOut(500);
		    return false;
	    },
	    onChange: function (hsb, hex, rgb) {
	      colorBox.val(hex);
		    colorBox.css({color:'#'+hex, backgroundColor:'#'+hex});
	    }
    });
  }

  $('input.delete[type=checkbox]').live('click', function(event) {
    $(this).closest('li,tr').fadeOut();
  });

});

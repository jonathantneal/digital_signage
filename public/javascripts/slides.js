$(document).ready(function() {

  // Date Picker
  $('.publish_at input[type=text]').datepicker({dateFormat: "MM d, yy '12:00 AM'"});
  $('.unpublish_at input[type=text]').datepicker({dateFormat: "MM d, yy '11:59 PM'"});

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

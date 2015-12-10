$(document).ready(function() {
	
	$('#new_comment').submit(function() {
		var data = $('#new_comment').serialize();
		
		if($('#comment_content').val() != '') {
			$.ajax({
			  type: "POST",
			  url: "/comments",
			  data: data,
			  success: function(response) {
					$('#comments').append(response);
					$('#nocom').hide();
					$('#comment_content').val('');
			  }
			});
		}
		
		return false;
	});
});
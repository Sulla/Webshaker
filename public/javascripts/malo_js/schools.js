$(document).ready(function() {
	$('a.school_visibility').click(function() {
		var elem = $(this);
		var id = elem.attr('data-id');
		
		$.ajax({
		  type: "POST",
		  url: "/admin/schools/"+id+"/visibility",
		  data: "",
		  success: function(data) {
				if(data.validated == 'true') {
					elem.find('img').attr('src', '/images/ico/accept.png');
				} else {
					elem.find('img').attr('src', '/images/ico/cross.png');					
				}
		  }
		});
		
		return false;
	});
});
$(document).ready(function() {
	$('a.accept').click(function() {
		var id = $(this).attr('data-id');
		$.ajax({
		  type: "POST",
		  url: "/admin/workers",
		  data: "id=" + id,
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
		  	  $('#workers_' + id).remove();
		    }
		  }
		});
		return false;
	});
	
	$('a.refuse').click(function() {
		var id = $(this).attr('data-id');
		$.ajax({
		  type: "POST",
		  url: "/admin/workers/"+id,
		  data: "_method=delete",
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
		  	  $('#workers_' + id).remove();
		    }
		  }
		});
		return false;
	});
});
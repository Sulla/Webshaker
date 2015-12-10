$(document).ready(function() {
	$('.delete_worker').live('click', function() {
		var id = $(this).attr('data-id');
		
		if(confirm("Do you confirm the deletion?")) {
			$.ajax({
			  type: "POST",
			  url: "/workers/" + id,
			  data: "_method=delete",
			  complete: function(xhr, statusText) {
			  	if(xhr.status == 200) {
			  	  $('.employee_row[data-id="'+id+'"]').remove();
			    }
			  }
			});
		}
		
		return false;
	});
	
	$('.worker_admin').live('change', function() {
		var id = $(this).attr('data-id');
		var admin = $(this).attr('checked');
		
		if(!admin) {
			admin = 'no'	
		}
		
		$.ajax({
		  type: "POST",
		  url: "/workers/" + id,
		  data: { _method: 'put', worker: { admin: admin } },
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
		    }
		  }
		});
	});
	
	$('.worker_title').keyup(function() {
		var id = $(this).attr('data-id');
		var title = $(this).val();
		
		$.ajax({
		  type: "POST",
		  url: "/workers/" + id,
		  data: { _method: 'put', worker: { title: title } },
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
		    }
		  }
		});
	});
	
	$('.accept_worker').click(function() {
		var id = $(this).attr('data-id');
		
		$.ajax({
		  type: "POST",
			dataType: "json",		
		  url: "/workers/" + id + "/accept",
		  data: "",
		  success: function(data) {
	  	  $('.request_row[data-id="'+id+'"]').remove();
	
				var new_line = "<tr class=\"employee_row\" data-id=\"{{worker_id}}\">" +
					"<td>{{name}}</td>" +
					"<td><input type=\"checkbox\" class=\"worker_admin\" data-id=\"{{worker_id}}\"/></td>" +
					"<td>" +
						"<a href=\"#\" class=\"delete_worker\" data-id=\"{{worker_id}}\"><img src=\"/images/ico/delete.png\"/></a>" +
					"</td></tr>";

				var html = Mustache.to_html(new_line, data);
				$('#employees_tbody').append(html);
		  }
		});
		
		return false;
	});
	
	$('.refuse_worker').click(function() {
		var id = $(this).attr('data-id');
		
		$.ajax({
		  type: "POST",
		  url: "/workers/" + id + "/refuse",
		  data: "",
		  success: function(data) {
		  	 $('.request_row[data-id="'+id+'"]').remove();
		  }
		});
	});
	
	$('#user_avatar, #company_avatar').change(function() {
		$('#filename').html('<span class="pictos">P </span> ' + $(this).val());
		$('#filename').show();
	});
	
	if($('#filename')) {
		$('#filename').hide();
	}
	
	$("#send_invite").click(function() {
		$.ajax({
		  type: "POST",
		  url: "/companies/invite",
		  data: "email="+$('#email').val(),
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
					$('#email').val('');
					alert(xhr.responseText)
		    }
		  }
		});
		
		return false;
	});
});
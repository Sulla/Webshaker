$(document).ready(function() {
	$('a.post_visibility').click(function() {
		var elem = $(this);
		var id = elem.attr('data-id');
		
		$.ajax({
		  type: "POST",
		  url: "/admin/posts/"+id+"/visibility",
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
	
	$('a.accept_post, a.refuse_post').click(function() {
		var elem = $(this);
		var id = elem.attr('data-id');
		
		var value = elem.find('img').attr('src');
		if(value.indexOf('delete.png') > 0) {
			$('#clicked_item').val(id)
			jQuery.facebox('<textarea cols="50" rows="5" id="explanation"></textarea><br/><br/><div align="center"><input type="submit" id="submit_explanation" value="Valider"/></div><br/>');
		} else {
			$.ajax({
			  type: "POST",
			  url: "/admin/posts/"+id+"/validate",
			  data: "go=accept",
			  success: function(data) {
					elem.parent().html(data.date);
			  }
			});
		}
		
				return false;
	});
	
	$('#submit_explanation').live('click', function() {
		var id = $('#clicked_item').val();
		var elem = $('a.refuse_post[data-id="'+id+'"]');
		
		$.ajax({
		  type: "POST",
		  url: "/admin/posts/"+id+"/validate",
		  data: "go=refuse&message=" + $('#explanation').val(),
		  success: function(data) {
				elem.parent().html(data.date);
				jQuery(document).trigger('close.facebox');
		  }
		});
		
		return false;
	});
});
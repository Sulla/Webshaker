function enableUploader() {
	var id = $('#file-uploader').attr('data-id');
	var uploader = new qq.FileUploader({
	    element: document.getElementById('file-uploader'),
			allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
	    action: '/attachments?post_id='+id,
	    debug: false,
			onComplete: function(id, fileName, responseJSON){
				$('#attachments').append('<li id="attachment_'+responseJSON.picture.id+'"><span><img src="'+responseJSON.picture.picture_thumb+'"/></span><span><a href="#" class="delete" title="Delete" data-id="'+responseJSON.picture.id+'"><img src="/images/ico/cross.png"></a></span></li>');
			}	
	});
}

$(document).ready(function() {
	
	$('.show_posts').click(function() {
		$('#loading').toggleClass('hidden');
		
		var who = '';
		if($(this).hasClass('switch_all') || $(this).hasClass('switch_bookmark')) {
			if($(this).hasClass('switch_all')) {
				who = 'all';
				$('#filter_bookmark').removeClass('selected');
			}
			if($(this).hasClass('switch_bookmark')) {
				who = 'bookmark';
				$('#filter_all').removeClass('selected');			
			}
			
			$(this).toggleClass('selected');
		} else {
			if($(this).hasClass('first')) {
				$('a.show_data').removeClass('selected');
			}
			$('a.show_posts.first').removeClass('selected');
			$(this).toggleClass('selected');			
		}
		
		var post_type_id = "";
		$('a.show_data.selected').each(function(index) {
			post_type_id = post_type_id + $(this).attr('data-id') + '_';
		});
		post_type_id = post_type_id.slice(0,post_type_id.length-1);
		
		if(post_type_id == '') {
			post_type_id = '0';
		}
		
		$.ajax({
		  type: "GET",
		  url: "/posts.json?post_type_id=" + post_type_id + "&who=" + who,
		  data: "",
		  success: function(data) {
				$('#shaker').html(data.html);
				$('#loading').toggleClass('hidden');
				
				if(data.size >= 10) {
					$('#load_more').show();					
					$('#load_more').attr('data-page', 1);
				} else {
					$('#load_more').hide();
				}
		  }
		});
		
		return false;
	});
	
	$('#submit_shaker').click(function() {
		if($('#post_type_id').val() == '2') {
			if($("ul#attachments > li").length == 0) {
				alert("You must upload at least one screenshot!");
				return false;
			}
		}
	});
	
	/*$('#new_post').submit(function() {
		var data = $('#new_post').serialize();
		var post_type_id = $('a.new_post.selected').attr('data-id');
		
		$.ajax({
		  type: "POST",
		  url: "/posts",
		  data: data + "&post_type_id=" + post_type_id,
		  success: function(data) {
				$('#shaker').prepend(data.html);
		  }
		});
		
		return false;
	});*/
	
	$('a.new_post').click(function() {
		var id = $(this).attr('data-id');
		
		$('a.new_post').removeClass('selected');
		$(this).addClass('selected');
		
		$('.post_desc').addClass('hidden');
		$('#post_type_'+$(this).attr('data-id')).removeClass('hidden');
		
		$.ajax({
		  type: "GET",
		  url: "/posts/new?post_type_id=" + id,
		  data: "",
		  success: function(data) {
				$('#form').html(data);
				refresh();
				
				if(id == 2) {
					enableUploader();
				}
		  }
		});
		
		return false;
	});
	
	$('a#load_more').click(function() {
		$('#loading').toggleClass('hidden');
		var page = parseInt($(this).attr('data-page'));
		
		$.ajax({
		  type: "GET",
		  url: "/posts.json?page=" + page,
		  data: "",
		  success: function(data) {
				$('#shaker').append(data.html);
				if(data.size >= 10) {
					$('#load_more').attr('data-page', page + 1);
				} else {
					$('#load_more').hide();
				}
				
				$('#loading').toggleClass('hidden');
		  }
		});
		return false;
	});
	
	$('a.delete').live('click', function(){
		var id = $(this).attr('data-id');
		$.ajax({
		  type: "POST",
		  url: "/attachments/"+id,
		  data: "_method=delete",
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
		  	  $('#attachment_'+id).remove();
		    }
		  }
		});
		
		return false;
	});
	
	$('a.post_visibility').click(function() {
		var elem = $(this);
		var id = elem.attr('data-id');
		
		$.ajax({
		  type: "POST",
		  url: "/posts/"+id+"/visibility",
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
	
	$('a#repost_btn').click(function() {
		$('#repost').val('true');
		$('#new_post').submit();
		return false;
	});
});
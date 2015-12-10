$(document).ready(function() {
	$('#reset').hide();
	
	$('a.directory_listing').click(function() {
		$('#treated_ids').val('');
		$('#loading').toggleClass('hidden');
		
		var role_id = $(this).attr('data-id');
		var name_filter = $('#name_filter').val();
		
		$('a.directory_listing').removeClass('selected');
		$(this).addClass('selected');
		$('#listing').attr('data-page', 0);
		
		$.ajax({
		  type: "GET",
			dataType: "json",		
		  url: "/directory/search?role_id=" + role_id + "&page=0" + "&name_filter=" + name_filter,
		  success: function(data) {
				$('#listing').html('');
				$('#listing').append(data.html);
				$('#treated_ids').val(data.treated_ids);
				
				if(data.size >= 10) {
					$('#load_more').show();
				} else {
					$('#load_more').hide();
				}
				
				$('#loading').toggleClass('hidden');
		  }
		});
		
		return false;
	});
	
	$('#load_more').click(function() {
		$('#loading').toggleClass('hidden');
		
		var role_id = $('a.directory_listing.selected').attr('data-id');
		var page = parseInt($('#listing').attr('data-page'));
		var name_filter = $('#name_filter').val();
		var treated_ids = $('#treated_ids').val();
		page++;
				
		$('#listing').attr('data-page', page);
		
		$.ajax({
		  type: "GET",
			dataType: "json",				
		  url: "/directory/search?role_id=" + role_id + "&page=" + page + '&name_filter=' + name_filter + '&treated_ids=' + treated_ids,
		  success: function(data) {
				$('#listing').append(data.html);
				$('#treated_ids').val(treated_ids + '_' + data.treated_ids);
				if(data.size < 10) {
					$('#load_more').hide();
				}
				
				$('#loading').toggleClass('hidden');
		  }
		});
		
		return false;
	});
	
	function filterDirectory() {
		$('#treated_ids').val('');
		$('#loading').toggleClass('hidden');
		
		var role_id = $('a.directory_listing.selected').attr('data-id');
		var name_filter = $('#name_filter').val();
		var sort_param = $('#sort_param').val();
		$('#listing').attr('data-page', 0);
		
		$.ajax({
		  type: "GET",
			dataType: "json",		
		  url: "/directory/search?role_id=" + role_id + "&page=0&name_filter=" + name_filter + "&sort_param=" + sort_param,
		  success: function(data) {
				$('#listing').html('');
				$('#listing').append(data.html);
				
				if(data.size >= 12) {
					$('#load_more').show();
				} else {
					$('#load_more').hide();
				}
				
				$('#loading').toggleClass('hidden');
		  }
		});
	}
	
	$('#filter').click(function() {
		filterDirectory();
		$('#reset').show();
		return false;	
	});
	
	$('#reset').click(function() {
		$('#name_filter').val('');
		filterDirectory();
		$('#reset').hide();
		return false;
	});
	
	$('#sort_param').change(function() {
		filterDirectory();
	});
});
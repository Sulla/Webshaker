$(document).ready(function() {
	$('.show_types, .show_cats').click(function() {
		$('#loading').toggleClass('hidden');
		
		var classname = 'show_types';
		
		if($(this).hasClass('show_cats')) {
			classname = 'show_cats';
		}
		
		if($(this).hasClass('first')) {
			$('a.'+classname).removeClass('selected');
		}
		$('a.'+classname+'.first').removeClass('selected');
		$(this).toggleClass('selected');
		
		var job_type_id = "";
		$('a.show_types.selected').each(function(index) {
			job_type_id = job_type_id + $(this).attr('data-id') + '_';
		});
		job_type_id = job_type_id.slice(0,job_type_id.length-1);
		
		if(job_type_id == '') {
			job_type_id = '0';
		}
		
		var job_category_id = "";
		$('a.show_cats.selected').each(function(index) {
			job_category_id = job_category_id + $(this).attr('data-id') + '_';
		});
		job_category_id = job_category_id.slice(0,job_category_id.length-1);		
		
		if(job_category_id == '') {
			job_category_id = '0';
		}
		
		$.ajax({
		  type: "GET",
		  url: "/jobs.json?job_type_id=" + job_type_id + "&job_category_id=" + job_category_id,
		  data: "",
		  success: function(data) {
				$('#jobs').html(data.html);
				$('#loading').toggleClass('hidden');
		  }
		});
		
		return false;
	});
});
$(document).ready(function() {
	$('.delete').click(function() {
			if(confirm("Do you confirm the deletion?")) {
				var id   = $(this).attr('data-id');
				var type = $(this).attr('data-type');

				$.ajax({
				  type: 'POST',
				  url: '/admin/' + type + '/' + id,
				  data: '_method=delete',
				  complete: function(xhr, statusText) {
				  	if(xhr.status == 200) {
							$('#' + type + '_' + id).remove();
				    }
				  }
				});
			}

			return false;
		});
});
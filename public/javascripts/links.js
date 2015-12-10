$(document).ready(function() {
	
	var new_line = 
		"<li data-id=\"{{id}}\" class=\"link_row tableLink\">" +
			"<img src=\"{{type_icon}}\"/><h4><a href=\"{{url}}\">{{name}}</a></h4>" +
			"<a href=\"#\" class=\"delete_link right\" data-id=\"{{id}}\"><span class=\"pictos\">#</span></a>" +
			"<a href=\"#\" class=\"edit_link right\" data-id=\"{{id}}\"><span class=\"pictos\" action='edit'>p</span></a>" +
			"<hr class=\"clear\" />" +	
		"</li>";
	
	$('#add_link').submit(function() {
		var name     = $('#link_name').val();
		var url      = $('#link_url').val();
		var type     = $('#link_type').val();
		var linkable = $('#linkable').val();
		
		var params = {
	    name: name,
	    url: url,
			type: type,
			linkable: linkable
    };

		params = $.param(params);
		
		$.ajax({
		  type: "POST",
		  url: "/links",
		  data: params,
		  success: function(data) {
			
				var view = {
					id: data.id,
				  name: name,
				  url: url,
					type_icon: data.type_icon,
					type_name: data.type_name
				}
				
				var html = Mustache.to_html(new_line, view);
	  	  $('#links_list').append(html);
		  }
		});
		
		return false;
	});
	
	$('.delete_link').live('click', function() {
		var id = $(this).attr('data-id');
		var linkable = $('#linkable').val();
		
		if(confirm("Do you confirm the deletion?")) {
			$.ajax({
			  type: "POST",
			  url: "/links/" + id,
			  data: "_method=delete&linkable=" + linkable,
			  complete: function(xhr, statusText) {
			  	if(xhr.status == 200) {
			  	  $('.link_row[data-id='+id+']').remove();
			    }
			  }
			});
		}
		
		return false;
	});
	
	$('.edit_link').live('click', function() {
		var id       = $(this).attr('data-id');
		var span     = $(this).find('span');
		var action   = span.attr('action');
		var row      = $('.link_row[data-id='+id+']');
		var linkable = $('#linkable').val();
		
		if(action == 'edit') {
			span.html('2');
			span.attr('action', 'save');
			
			$.getJSON('/links/'+ id, function(link) {
				var options = $('#link_type').html();
				
				var new_line =
						"<img src=\"{{type}}\"/><h4><a href=\"{{url}}\">{{name}}</a></h4>" +	
						"<hr class=\"clear\" />" +
						"<ul>" +
							"<li><label>Name</label><input type=\"text\" value=\"{{name}}\" name=\"name\"/></li><hr class=\"clear\" />" +
							"<li><label>URL</label><input type=\"text\" value=\"{{url}}\"/ name=\"url\"></li><hr class=\"clear\" />" +
							"<li><label>Type</label><select name=\"type\">" + options + "</select></li><hr class=\"clear\" />" +						
						"</ul>" +
						"<a href=\"#\" class=\"delete_link right\" data-id=\""+id+"\"><span class=\"pictos\">#</span></a>" +
						"<a href=\"#\" class=\"edit_link right\" data-id=\""+id+"\"><span class=\"pictos\" action=\"save\">2</span></a>"

				var html = Mustache.to_html(new_line, link);
				row.html(html);
				row.find('select').val('' + link.link_type_id);
			});
		} else {
			span.html('p');
			span.attr('action', 'edit');
			
			var name     = row.find('input[name="name"]').val();
			var url      = row.find('input[name="url"]').val();
			var type     = row.find('select').val();
			
			$.ajax({
			  type: "POST",
			  url: "/links/" + id,
				dataType: "json",
			  data: "_method=put&name=" + name + "&url=" + url + "&type=" + type + "&linkable=" + linkable,
			  success: function(data) {
					var html = Mustache.to_html(new_line, data);
					row.replaceWith(html);
			  }
			});
			
		}
		
		return false;
	});
	
	$('.alertable').change(function() {
		var model = $(this).attr('data-type');
		$.ajax({
		  type: "POST",
		  url: "/alerts?model=" + model,
		  data: "",
		  complete: function(xhr, statusText) {
		  	if(xhr.status == 200) {
		    }
		  }
		});
	});
	
});
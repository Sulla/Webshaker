$(document).ready(function() {
	$('#map').jMapping({
		default_zoom_level: 13
	});
	
	$('#join_company').submit(function() {
		if(confirm("Are you sure you want to join this company as an employee? A validation request will be send to the manager.")) {
			return true;
		}
		return false;
	}); 
	
	$('#admin_company').submit(function() {
		if(confirm("Are you sure you want to join this company as an employee? A validation request will be send to the manager.")) {
			return true;
		}
		return false;
	});
});
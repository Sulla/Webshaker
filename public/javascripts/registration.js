$(document).ready(function() {
	$('#user_role').change(function() {
		$('.hidable').removeClass('hidden').addClass('hidden');
		$('.role_' + $(this).val()).removeClass('hidden');
	});
	
	$('#create_school').click(function() {
		$('#create_school_form').toggleClass('hidden');
		return false;
	});
	
	$('#create_school_btn').click(function() {
		var name = $('#school_name').val();
		
		$.ajax({
		  type: "POST",
		  url: "/schools",
		  data: "name="+name,
		  success: function(data) {
				if(data.school_id != 0) {
					$('#user_school').append('<option value="'+data.school_id+'">'+data.school_name+'</option>');
					$('#create_school_form').toggleClass('hidden');
					$('#user_school').val(''+data.school_id+'');
					$('#user_school_id').val(''+data.school_id+'');
				} else {
					alert('Cette école existe déjà!');
				}
		  }
		});
		return false;
	});
	
	$('#user_school').change(function() {
		$('#user_school_id').val($(this).val());
	});
	
	$('.role_2 #create_company').click(function() {
		$('.role_'+$('#user_role').val()).find('#create_company_form').toggleClass('hidden');
		$('#existing_owner').hide();
		return false;
	});
	
	
	$('input[type="radio"][name="user[company_admin_request]"]').change(function() {
		var val = $('input[name="user[company_admin_request]"]:checked').val();
		if(val == '0') {
			$('#user_company_admin_request').val('0');			
		} else {
			$('#user_company_admin_request').val('on');
		}
	});
	
	$('input[type="radio"][name="owner"]').change(function() {
		var val = $('input[name=owner]:checked').val()
		if(val == '0') {
			$('#set_owner_email').show();
			$('#company_admin_request').attr('checked', false);			
			$('#user_company_admin_request').val('0');			
		} else {
			$('#set_owner_email').hide();
			$('#company_admin_request').attr('checked', true);
			$('#user_company_admin_request').val('on');
		}
	});

	$('.role_2 #create_company_btn').click(function() {
		var name  = $('.role_'+$('#user_role').val()).find('#company_name').val();
		var owner = $('input[name=owner]:checked').val();
		var email = '';
		
		if(owner == '0') {
			email = $('#owner_email').val();
		}
		
		$.ajax({
		  type: "POST",
		  url: "/companies",
		  data: "name=" + name + "&owner=" + owner + "&email=" + email,
		  success: function(data) {
				if(data.company_id != 0) {
					$('.role_'+$('#user_role').val()).find('#user_company').append('<option value="'+data.company_id+'">'+data.company_name+'</option>');
					$('.role_'+$('#user_role').val()).find('#create_company_form').toggleClass('hidden');
					$('.role_'+$('#user_role').val()).find('#user_company').val(''+data.company_id+'');
					$('.role_'+$('#user_role').val()).find('#user_company_id').val(''+data.company_id+'');
				} else {
					alert('Cette société existe déjà!');
				}
		  }
		});
		return false;
	});

	$('.role_2 select#user_company').change(function() {
		var id = $(this).val();
		
		$('#user_company_admin_request').val('0');
		$('.role_'+$('#user_role').val()).find('input#user_company_id').val(id);
		
		$.ajax({
		  type: "GET",
		  url: "/companies/" + id + "/has_admin",
		  data: "",
		  success: function(data) {
				if(data.has_admin == 'true') {
					$('#existing_owner').show();
				} else {
					$('#existing_owner').hide();					
				}
		  }
		});
	});
	
	$('#user_avatar').change(function() {
		$('#filename').html('<span class="pictos">P </span> ' + $(this).val());
		$('#filename').show();
	});
	
	$('#filename').hide();
});
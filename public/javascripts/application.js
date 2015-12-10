function refresh() {
	$('.datepicker').datepicker();
	$('.datepicker').datepicker("option", "dateFormat", "dd/mm/yy");
	
	var val = $('.datetimepicker').val();
	$('.datetimepicker').datetimepicker();
	$('.datetimepicker').datepicker("option", "dateFormat", "dd/mm/yy");
	$('.datetimepicker').val(val);
}

$('#tabsTop').tabs();
$(document).ready(function() {

	refresh();
	Shadowbox.init({
		handleOversize:"drag"
	});
	
	$(".focusable").focus(function () {
  	$(this).val('');
  });
	
	$('.add_bookmark').live('click', function() {
		var id   = $(this).attr('data-id');
		var type = $(this).attr('data-type');
		var parent = $(this).parent();
		var action = parent.attr('class');
		
		$.ajax({
		  type: "POST",
		  url: "/bookmarks",
		  data: "id=" + id + "&type=" + type,
		  success: function(response) {
				if(action == 'action') {
					parent.attr('class', 'action actionOK');
					$('#bookmark_label').html('Remove bookmark');
				} else {
					parent.attr('class', 'action');						
					$('#bookmark_label').html('Add bookmark');						
				}
		  },
			error: function(response) {
				window.location = 'http://' + window.location.host + '/users/sign_in';
			}
		});
		
		return false;
	});
	
	/*$(".hide").click(
		function () {
			$(this).parent().fadeTo(500, 0, function () { // Links with the class "close" will close parent
				$(this).slideUp(500);
			});
			return false;
		}
	);*/
	
	$('.like_it').live('click', function() {
		var elem = $(this);
		var id   = elem.attr('data-id');
		var type = elem.attr('data-type');
		var parent = elem.parent();
		var action = parent.attr('class');
				
		$.ajax({
		  type: "POST",
		  url: "/likes",
		  data: "id=" + id + "&type=" + type,
		  complete: function(xhr, statusText) {
				if(xhr.status == 200) {
					var likes = parseInt($('#like_count').html());
					if(action == 'action') {
						likes = likes + 1;
						parent.attr('class', 'action actionOK');
						$('#like_label').html('Unlike');
					} else {
						likes = likes - 1;
						parent.attr('class', 'action');						
						$('#like_label').html('Like');						
					}
					
					$('#like_count').html(likes);
				} else {
					window.location = 'http://' + window.location.host + '/users/sign_in';
				}
		  }
		});
			
		return false;
	});
	
	$('.like_it_small').live('click', function() {
		var elem = $(this);
		var id   = elem.attr('data-id');
		var type = elem.attr('data-type');
		var parent = elem.parent();
		var action = parent.hasClass('actionOK');
				
		$.ajax({
		  type: "POST",
		  url: "/likes",
		  data: "id=" + id + "&type=" + type,
		  complete: function(xhr, statusText) {
				if(xhr.status == 200) {
					var likes = parseInt($('span.like_count[data-id="'+id+'"]').html());
					if(action) {
						console.log('if');
						likes = likes - 1;
						parent.removeClass('actionOK');						
					} else {
						console.log('else');						
						likes = likes + 1;
						parent.addClass('actionOK');
					}
					
					$('span.like_count[data-id="'+id+'"]').html(likes);
				} else {
					window.location = 'http://' + window.location.host + '/users/sign_in'
				}
		  }
		});
			
		return false;
	});
	
	
// Login Form

$(function() {
    var button = $('#loginButton');
    var box = $('#loginBox');
    var form = $('#loginBox form');
    button.removeAttr('href');
    button.mouseup(function(login) {
        box.toggle();
        button.toggleClass('active');
    });
    form.mouseup(function() { 
        return false;
    });
    $(this).mouseup(function(login) {
        if(!($(login.target).parent('#loginButton').length > 0)) {
            button.removeClass('active');
            box.hide();
        }
    });
});


	$('#keywords').keyup(function() {
		var value = $(this).val();
		if(value.length > 2) {
			$.ajax({
			  type: "GET",
			  url: "/search.json?keywords=" + value,
			  data: "",
			  success: function(data) {
					$('#search #results').html(data.html);
					$('#search #results').show();
			  }
			});
		}
	});	
	
	$('#memberInfos, #memberInfos > img').click(function(event) {
		$('#userbox').toggleClass('show').toggleClass('hide');
		event.stopPropagation();
	});
	
	$('#sign_in').click(function(event) {
		$('#loginbox').toggleClass('show').toggleClass('hide');
		event.stopPropagation();
	});
	
	$("body").click
	(
	  function(e) {
	    if(e.target.id !== "userbox" &&  $(e.target).parents('#userbox').length <= 0) {
	      $('#userbox').removeClass('show').addClass('hide');
	    }
			if(e.target.id !== 'results' && $(e.target).parent().attr('id') !== "results") {
				$('#search #results').hide();
			}
			if(e.target.id !== "loginbox" && $(e.target).parents('#loginbox').length <= 0) {
	      $('#loginbox').removeClass('show').addClass('hide');
	    }
	  }
	);
	
	$(".hide_flash").click(
		function () {
			$(this).parent().fadeTo(500, 0, function () { // Links with the class "close" will close parent
				$(this).slideUp(500);
			});
			return false;
		}
	);
});


/*Tooltip*/
$(function(){
  $(".tooltip").tipTip({
    edgeOffset: 1,
    delay: 0,
    position:'bottom'
  });
})







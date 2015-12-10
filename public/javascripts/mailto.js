jQuery(function($) {
	var Engine = {
		utils : {
			links : function(){
				$('a[rel*="external"]').click(function(e){
					e.preventDefault();
					window.open($(this).attr('href'));
				});
			},
			mails : function(){
				$('a[href^="mailto:"]').each(function(){
					var mail = $(this).attr('href').replace('mailto:','');
					var replaced = mail.replace('/at/','@');
					$(this).attr('href','mailto:'+replaced);
					if($(this).text() === mail) {
						$(this).text(replaced);
					}
				});
			},
		},
	};
	Engine.utils.links();
	Engine.utils.mails();
});
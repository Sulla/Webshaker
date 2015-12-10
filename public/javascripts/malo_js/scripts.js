$(document).ready(function() {
  // On cache les sous-menus
	// sauf celui qui porte la classe "open_at_load" :
	$("ul.subMenu:not('.open_at_load')").hide();
	// On selectionne tous les items de liste portant la classe "toggleSubMenu"
	
	// et on remplace l'element span qu'ils contiennent par un lien :
	$("li.toggleSubMenu span").each( function () {
		// On stocke le contenu du span :
		var TexteSpan = $(this).text();
		$(this).replaceWith('<a href="" title="Afficher le sous-menu">' + TexteSpan + '</a>') ;
	});
	
	// On modifie l'evenement "click" sur les liens dans les items de liste
	// qui portent la classe "toggleSubMenu" :
	$("li.toggleSubMenu > a").click( function () {
		// Si le sous-menu etait deja ouvert, on le referme :
		if ($(this).next("ul.subMenu:visible").length != 0) {
			$(this).next("ul.subMenu").slideUp("normal", function () { $(this).parent().removeClass("open") } );
		}
		// Si le sous-menu est cache, on ferme les autres et on l'affiche :
		else {
			$("ul.subMenu").slideUp("normal", function () { $(this).parent().removeClass("open") } );
			$(this).next("ul.subMenu").slideDown("normal", function () { $(this).parent().addClass("open") } );
		}
		// On empêche le navigateur de suivre le lien :
		return false;
	});
			
	$(".hide").click(
		function () {
			$(this).parent().fadeTo(500, 0, function () { // Links with the class "close" will close parent
				$(this).slideUp(500);
			});
			return false;
		}
	);
				
	$(".subMenu a").hover(function () {
		$(this).stop().animate({ paddingRight: "25px" }, 200);
	},
	function () {
		$(this).stop().animate({ paddingRight: "15px" });
	}); 
	
	
	$('.check_every_checkbox').click(function() {
	      $(this).parents('form').find('input:checkbox').attr('checked', $(this).is(':checked'));   
	});
	
	 $('a[rel*=facebox]').facebox();
	 
	 //When page loads...
 	 $(".tab_content").hide(); //Hide all content
 	 $("ul.tabs li:first").addClass("active").show(); //Activate first tab
 	 $(".tab_content:first").show(); //Show first tab content
 
 	//On Click Event
 	 $("ul.tabs li").click(function() {
     $("ul.tabs li").removeClass("active"); //Remove any "active" class
 	 $(this).addClass("active"); //Add "active" class to selected tab
 	 $(".tab_content").hide(); //Hide all tab content
 
 	 var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
 	 $(activeTab).fadeIn(); //Fade in the active ID content
 	 return false;
 	 });
	 
	 $(document).ready(function(){
	   $("div#search label").inFieldLabels();
	 });
	 	
});


console.log("hello world")
var sidebar = document.createElement('div');
		sidebar.id = "userDocsSidebar";
		sidebar.style.display = "none";
		console.log(sidebar)
		sidebar.style.cssText = "\
			position:fixed;\
			top:0px;\
			left:0px;\
			width:30%;\
			height:100%;\
			background:white;\
			z-index:999999;\
		";
		document.body.appendChild(sidebar);
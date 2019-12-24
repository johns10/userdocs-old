/*Handle requests from background.html*/
function handleRequest(request, sender, sendResponse) {
	if (request.callFunction == "toggleSidebar")
		toggleSidebar();
}

var target = null
var path = null

document.onmouseover = function(event) {
	target = event.srcElement;
	path = getPathTo(target);
}

document.onkeydown = function(event) {
	var x = event.keyCode;
	if (x === 67) {
		message = {
			command: 'setSelector',
			selector: path
		}
		chrome.runtime.sendMessage(message, function(response) {
			console.log(response.farewell);
		});
	}
}
	
function getPathTo(element) {
	if (element.id !== '')
			return "//*[@id='"+element.id+"']";
	
	if (element === document.body)
			return element.tagName.toLowerCase();

	var ix= 0;
	var siblings= element.parentNode.childNodes;
	for (var i= 0; i<siblings.length; i++) {
			var sibling= siblings[i];
			
			if (sibling===element) return getPathTo(element.parentNode) + '/' + element.tagName.toLowerCase() + '[' + (ix + 1) + ']';
			
			if (sibling.nodeType===1 && sibling.tagName === element.tagName) {
					ix++;
			}
	}
}

function getPageXY(element) {
	var x= 0, y= 0;
	while (element) {
			x+= element.offsetLeft;
			y+= element.offsetTop;
			element= element.offsetParent;
	}
	return [x, y];
}

function toggleSidebar() {
	console.log('toggling sidebar')
	if(sidebarOpen) {
		/*
		var el = document.getElementById('userDocsSidebar');
		el.parentNode.removeChild(el);
		sidebarOpen = false;
		*/
	}
	else {
		/*
		var sidebar = document.createElement('div');
		sidebar.id = "userDocsSidebar";
		sidebar.style.display = "none";
		sidebar.style.cssText = "\
			position:fixed;\
			top:0px;\
			left:0px;\
			width:30%;\
			height:100%;\
			background:white;\
			z-index:999999;\
		";

		let liveSocket = new LiveSocket("/live", Socket)
		liveSocket.connect()
		document.body.appendChild(sidebar);
		sidebarOpen = true;
		*/
	}
}

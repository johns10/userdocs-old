userDocsExtensionId = 'hfgglmmpokiccigccbmoehlbbijaocpd';

var extensionWindowId = null
var extensionTabId = null

chrome.tabs.onUpdated.addListener(function(tabId) {
	chrome.pageAction.show(tabId);
});

chrome.tabs.getSelected(null, function(tab) {
	chrome.pageAction.show(tab.id);
});

chrome.runtime.onMessage.addListener(
	function(request, sender, sendResponse) {
		console.log(sender.tab ?
							"from a content script:" + sender.tab.url :
							"from the extension");
	if (request.command == "setSelector") {
		console.log(request);
		chrome.tabs.sendMessage(extensionTabId, request);
		sendResponse({farewell: "goodbye"});
	} else if (request.command == "register") {
		sendResponse({result: "registered"});
	}
});
	
chrome.pageAction.onClicked.addListener(function(tab) {
	chrome.windows.create({
		url: chrome.runtime.getURL("index.html"),
		type: "popup"},
			function(window) {
				extensionWindowId = window.id;
				extensionTabId = window.tabs[0].id;
				console.log(extensionWindowId)
				console.log(extensionTabId)
			});
});

console.log( 'Background.html done.' );
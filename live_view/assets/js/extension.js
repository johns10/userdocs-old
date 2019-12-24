chrome.runtime.onMessage.addListener(
	function(request, sender, sendResponse) {
		console.log(sender.tab ?
							"from a content script:" + sender.tab.url :
							"from the extension");
	if (request.command == "setSelector") {
    result = setSelector(request.selector);
		sendResponse({result: result});
	}
});

function setSelector(value) {
  try {
    document.getElementById("userdocs-selector-form-field").value = value;
    return true
  }
  catch(error) {
    console.log(error)
    return false
  }
}
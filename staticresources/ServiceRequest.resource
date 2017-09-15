var j$ = jQuery.noConflict();
j$(document).ready(function () {
	
	j$(".cancel").click(function () {
		if (!sforce.console.isInConsole()) {
			return true;
		}
		
		sforce.console.getFocusedSubtabId(function (result) {
			if (result.success) {
				log('getFocusedSubtabId success: ' + result.id);
				sforce.console.closeTab(result.id);
				log('closeTab called');
			} else {
				log('getFocusedSubtabId failed: ' + result.id);
			}
			
		});
		return false;
	});

	function log(value) {
		if (window.console && window.console.log) window.console.log(value);
	}
	
});

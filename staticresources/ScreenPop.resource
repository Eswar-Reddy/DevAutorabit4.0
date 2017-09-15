var j$ = jQuery.noConflict();
j$(document).ready(function () {

	if (sforce.console.isInConsole()) {
		sforce.console.getFocusedPrimaryTabId(function(result) {
			sforce.console.setTabTitle(ani, result.id);
		});	
	}

	j$(".account, .contact, .case, .opportunity, .campaign, .dealer").click(function () {
		
		if (!sforce.console.isInConsole()) {
			return true;
		}
		
		var responses = [];
		var subtabCount;

		var attrId = j$(this).attr("id");
		var attrHref = j$(this).attr("href");
		var tabLabel = j$(this).attr("title"); 

		log("attrId: " + attrId);
		var objectId15;
		if (attrId) {
			objectId15 = attrId.substring(0, 15);
			log('objectId15: ' + objectId15);
		} else {
			return false;
		}

		sforce.console.getFocusedPrimaryTabId(function (result) {
			var primaryTabId = result.id;
			sforce.console.getSubtabIds(primaryTabId, function (subtabIdResult) {
				log('subtabIdResult.ids: ' + subtabIdResult.ids);
				subtabCount = subtabIdResult.ids.length;
				j$.each(subtabIdResult.ids, function (index, value) {
					log('index/value: ' + index + '/' + value);
					sforce.console.getPageInfo(value , function(pageInfoResult) {
						var pageInfo = JSON.parse(pageInfoResult.pageInfo);
						log('pageInfo.objectId/subtabId: ' + pageInfo.objectId + '/' + value);
						var resp = {objectId : pageInfo.objectId, subtabId : value};
						responses.push(resp);
						if (responses.length == subtabCount) {
							var subtabId;
							for (var i=0, len=responses.length; i<len; i++) {
								if (responses[i].objectId == objectId15 || responses[i].objectId == attrId) {
									subtabId = responses[i].subtabId;
								}
							}
							
							if (subtabId) {
								log('focusSubtabById');
								sforce.console.focusSubtabById(subtabId, focusSuccess);
							} else {
								log('openSubtab');
								sforce.console.openSubtab(primaryTabId, attrHref, true, tabLabel, null, openSuccess, attrId);
							}
						}
					});
				});

			});
		});

		return false;
	});

	var openSuccess = function openSuccess(result) {
		if (result.success == true) {
			log('subtab successfully opened: ' + result.id);
		} else {
			log('subtab cannot be opened');
		}
	};

	var focusSuccess = function focusSuccess(result) {
		if (result.success == true) {
			log('Going to the subtab was successful');
		} else {
			log('Going to the subtab was not successful');
		}
	};
	
	function log(value) {
		if (window.console && window.console.log) window.console.log(value);
	}
	
});

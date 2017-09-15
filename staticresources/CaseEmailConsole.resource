var j$ = jQuery.noConflict();
j$(document).ready(function() {

	var onFocusedSubtabCallback = function (result) {
	if (window.console) console.log('Focus changed to a different subtab. The subtab Id is:' + result.id + 'and the object Id is:' + result.objectId);
		
		if (result != null && result.objectId != null) {
			var objectPrefix = result.objectId.substring(0,3);
			
			if (objectPrefix == "02s") {
				var queryStr = "SELECT Id, ParentId, Status FROM EmailMessage WHERE Id = '" + result.objectId + "'";
				if (window.console) console.log('queryStr: ' + queryStr); 
				
				var queryResult = sforce.connection.query(queryStr);
				if (queryResult != null) {
					var records = queryResult.getArray("records");
					if (records != null && records.length > 0) {
						var emailMessageRec = records[0];
						if (window.console) console.log('emailMessageRec: ' + emailMessageRec);
						
						if (emailMessageRec.ParentId != null) {
							updateCase(emailMessageRec.ParentId);
						}
						
					}
				}
				
			}
		}
	};

	sforce.console.onFocusedSubtab(onFocusedSubtabCallback);
	
	var updateCase = function(caseId) {
		var queryStr = "SELECT Id, New_Emails_Count__c, (SELECT Id, Status FROM EmailMessages WHERE Status = '0') FROM Case WHERE Id = '" + caseId + "'";
		if (window.console) console.log('queryStr: ' + queryStr);
		
		var queryResult = sforce.connection.query(queryStr);
		if (queryResult != null) {
			var records = queryResult.getArray('records');
			if (records != null && records.length > 0) {
				var caseRec = records[0];
				if (window.console) console.log('caseRec: ' + caseRec);
				
				var newEmailsCount = 0;
				if (caseRec.EmailMessages != null) {
					if (window.console) console.log("caseRec.EmailMessages.size: " + caseRec.EmailMessages.size);
					newEmailsCount = caseRec.EmailMessages.size;
				}
				
				// we are getting value like 1.0 instead if 1. need to convert to int. otherwise case will be updated always
				var emailsCount = 0;
				if (caseRec.New_Emails_Count__c != null) {
					emailsCount = float2int(caseRec.New_Emails_Count__c);
				}

				if (window.console) console.log("caseRec.New_Emails_Count__c/emailsCount/newEmailsCount: " + caseRec.New_Emails_Count__c + "/" + emailsCount + "/" + newEmailsCount);
				
				if (emailsCount != newEmailsCount) {
					
					var caseObj = new sforce.SObject("Case");
					caseObj.Id = caseRec.Id;
					caseObj.New_Emails_Count__c = newEmailsCount;
					
					var updateResult = sforce.connection.update([caseObj]);
					
					if (updateResult) {
						if (updateResult[0].getBoolean("success")) {
							if (window.console) console.log("case with id " + updateResult[0].id + " updated");
						} else {
							if (window.console) console.log("failed to update case " + updateResult[0]);
						}
					} else {
						if (window.console) console.log("updateResult: " + updateResult);
					}
				}
			}
		}
	};
	
	function float2int(value) {
		return value | 0;
	}

});
		
		
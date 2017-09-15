var j$ = jQuery.noConflict();
j$(document).ready(function() {
	
	var locationRef = '' + window.location.href;
	var viewStringInd = locationRef.lastIndexOf('/');
	var replyString = '/_ui/core/email/author/EmailAuthor?email_id=';
	var replyStringInd = locationRef.lastIndexOf(replyString);
	var recordId;
	
	if (replyStringInd >= 0) {
		recordId = locationRef.substring(replyStringInd + replyString.length, replyStringInd + replyString.length + 15);
	} else if (viewStringInd >= 0) {
		recordId = locationRef.substring(viewStringInd + 1, viewStringInd + 16);
	}
	
	if (window.console) console.log('recordId: ' + recordId);
		
	if (recordId != null && recordId.length == 15) {
		var objectPrefix = recordId.substring(0,3);

		if (window.console) console.log('recordId/objectPrefix: ' + recordId + '/' + objectPrefix);
		
		// Inbound Email Message
		if (objectPrefix == "02s") {
			var emailMessageRecords = sforce.connection.query('SELECT Id, ParentId, Status FROM EmailMessage WHERE Id = \'' + recordId + '\'');
			if (emailMessageRecords != null) {
				var emailMessageRec = emailMessageRecords.getArray('records')[0];
				if (window.console) console.log('emailMessageRec: ' + emailMessageRec);

				// New=0, Read=1, Replied=2, Sent=3, Forwarded=4, Draft=5
				var caseRecords = sforce.connection.query("SELECT Id, New_Emails_Count__c, (SELECT Id, Status FROM EmailMessages WHERE Status = '0') FROM Case WHERE Id = '" + emailMessageRec.ParentId + "'");
				if (caseRecords != null) {
					var caseRec = caseRecords.getArray('records')[0];
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
						
						var result = sforce.connection.update([caseObj]);
						
						if (result) {
							if (result[0].getBoolean("success")) {
								if (window.console) console.log("case with id " + result[0].id + " updated");
							} else {
								if (window.console) console.log("failed to update case " + result[0]);
							}
						} else {
							if (window.console) console.log("update result: " + result);
						}

					}
				}
				
			}
		}
	}

	function float2int(value) {
		return value | 0;
	}
	
});


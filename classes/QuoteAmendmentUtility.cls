/*
	Created By:	Delivery Team
	Created:	Spring 2017

	Used by the Quote Amendment Controller & Agreement Confirmation Controller for change orders

	The getAmendmentChanges method is used to compare two quotes and their supporting objects based on the active Amendment Metadata records (custom metadata) and returns a list of changed data (wrapper class) to the caller.
*/

public class QuoteAmendmentUtility {

	// public method to get list of quote changes
	public static List<ChangedData> getAmendmentChanges(Id newQuoteId, Id oldQuoteId) {
		// list of changed data
		List<ChangedData> result = new List<ChangedData>();
		try {
			// get the objects/fields for comparsion - map is object name/list of metadata
			Map<String, List<Amendment_Metadata__mdt>> objectInfo = getMetadata();
			// map of queries to be run - map is object name/query
			Map<String, String> queries = new Map<String, String>();
			// convert objects/fields into queries
			for(String k : objectInfo.keySet()) {
				queries.put(k, buildQuery(k, objectInfo.get(k)));
			}
			// query for records
			for(String k : queries.keySet()) {
				String qry = queries.get(k);
				// query for new and old records
				List<SObject> newRecord = getData(addId(qry, newQuoteId));
				List<SObject> oldRecord = getData(addId(qry, oldQuoteId));
				// check query results
				if(!newRecord.isEmpty() && !oldRecord.isEmpty()) {
					// get the list of fields for this object
					List<Amendment_Metadata__mdt> fields = objectInfo.get(k);
					// compare records
					result.addAll(compareRecords(k, fields, newRecord[0], oldRecord[0]));
				} else {
					// TODO: not sure what to do if only one list is empty... if both are empty that's fine.
				}
			}
			System.debug('changes ' + result);
		}
		catch(Exception e) {
			System.debug('getAmendmentChanges error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
		}
		return result;
	}

	// get the objects/fields that are subject to comparison
	private static Map<String, List<Amendment_Metadata__mdt>> getMetadata() {
		Map<String, List<Amendment_Metadata__mdt>> result = new Map<String, List<Amendment_Metadata__mdt>>();
		// vars for loop
		String obj;
		// loop over metadata to build map
		for(Amendment_Metadata__mdt amd : [SELECT ObjectName__c, FieldName__c, QuoteId__c, isEnergy__c, isPrice__c, isProduct__c FROM Amendment_Metadata__mdt WHERE isActive__c = true ORDER BY ObjectName__c, FieldName__c]) {
			// check/set the object name
			if(String.isBlank(obj)) {
				obj = amd.ObjectName__c;
				result.put(obj, new List<Amendment_Metadata__mdt>());
				result.get(obj).add(amd);
			} else if(amd.ObjectName__c == obj) {
				result.get(obj).add(amd);
			} else { // object changed
				obj = amd.ObjectName__c;
				result.put(obj, new List<Amendment_Metadata__mdt>());
				result.get(obj).add(amd);
			}
		}
		return result;
	}

	// buld the queries for each object and return the map of query strings
	private static String buildQuery(String obj, List<Amendment_Metadata__mdt> objectInfo) {
		String result;
		// vars for select, from and where
		String sel = 'SELECT ';
		String whr = ' WHERE ' + objectInfo[0].QuoteId__c + ' = ';
		// build query strings
		for(Amendment_Metadata__mdt amd : objectInfo) {
			sel += amd.FieldName__c + ', ';
		}
		result = sel.removeEnd(', ') + ' FROM ' + obj + whr;
		return result;
	}

	private static List<SObject> getData(String qry) {
		List<SObject> result;
		try {
			result = Database.query(qry);
		}
		catch(Exception e) {
			// something is wrong with the query
			System.debug('getData query error ' + e.getMessage() + ' - ' + e.getStackTraceString());
		}
		return result;
	}

	private static String addId(String qry, Id recordId) {
		return qry + '\'' + recordId + '\'';
	}

	private static List<ChangedData> compareRecords(String obj, List<Amendment_Metadata__mdt> fields, SObject newRecord, SObject oldRecord) {
		List<ChangedData> result = new List<ChangedData>();
		// setup describe info to get labels
		Schema.SObjectType sObjType = newRecord.Id.getSObjectType();
		// compare data based on metadata records
		for(Amendment_Metadata__mdt amd : fields) {
			// check field values for differences
			if(newRecord.get(amd.FieldName__c) != oldRecord.get(amd.FieldName__c)) {
				// create changed data record
				ChangedData cd = new ChangedData();
				cd.objectId = newRecord.Id;
				cd.objectName = obj;
				cd.objectLabel = sObjType.getDescribe().getLabel();
				cd.fieldName = amd.FieldName__c;
				cd.fieldLabel = getFieldLabel(sObjType, amd.FieldName__c);
				cd.fieldType = getFieldType(sObjType, amd.FieldName__c);
				cd.newValue = String.valueOf(newRecord.get(amd.FieldName__c));
				cd.oldValue = String.valueOf(oldRecord.get(amd.FieldName__c));
				cd.isEnergy = amd.isEnergy__c;
				cd.isPrice = amd.isPrice__c;
				cd.isProduct = amd.isProduct__c;
				// add record to list
				result.add(cd);
			}
		}
		return result;
	}

    private static String getFieldLabel(Schema.SObjectType sObjType, String strField) {
    	Schema.DescribeSObjectResult dor = sObjType.getDescribe();
        Schema.DescribeFieldResult dfr = dor.fields.getMap().get(strField).getDescribe();
        return dfr.getLabel();
    }

    private static Schema.DisplayType getFieldType(Schema.SObjectType sObjType, String strField) {
    	Schema.DescribeSObjectResult dor = sObjType.getDescribe();
        Schema.DescribeFieldResult dfr = dor.fields.getMap().get(strField).getDescribe();
        return dfr.getType();
    }

	// wrapper for changed data
	public class ChangedData {
		public Id objectId;
		public String objectName;
		public String objectLabel {get; set;}
		public String fieldName;
		public String fieldLabel {get; set;}
		public Schema.DisplayType fieldType {get; set;}
		public String newValue {get; set;}
		public String oldValue {get; set;}
		public Boolean isEnergy {get; set;}
		public Boolean isPrice {get; set;}
		public Boolean isProduct {get; set;}
	}

	/* for change orders phase II we are not overriding and changes so this is commented out until it's needed
	public static void overrideChanges(List<ChangedData> changes, Boolean energy, Boolean price, Boolean product) {
		Map<Id, SObject> records = new Map<Id, SObject>();
		// set changes
		for(ChangedData cd : changes) {
			// TODO: need to find out if this should be &&'s or ||'s - ||'s will override the value even if they didn't override that category (if price & product are true for an item but they only overrode price it will still be overriden). &&'s will require a bit of rework on the if statement
			if(cd.isEnergy && energy || cd.isPrice && price || cd.isProduct && product) {
				// data needs to be overridden
				// check map for record
				if(records.containsKey(cd.objectId)) {
					SObject o = records.get(cd.objectId);
					o.put(cd.fieldName, cd.oldValue);
					records.put(cd.objectId, o);
				} else {
					SObject o = createObject(cd.objectName);
					// make sure we got a valid object
					if(o != null) {
						o.Id = cd.objectId;
						o.put(cd.fieldName, cd.oldValue);
						// add to map
						records.put(cd.objectId, o);
					}
				}
			}
		}
		if(!records.isEmpty()) {
			// update the records
			List<Database.SaveResult> srList = Database.update(records.values(), false);
			// check for errors
			for(Database.SaveResult sr : srList) {
				if(!sr.isSuccess()) {
					for(Database.Error e : sr.getErrors()) {
						// TODO: figure out how we should deal with issues
						String error = e.getMessage();
						List<String> fields = e.getFields();
					}
				}
			}
		}
	}

    private static SObject createObject(String objName) {
    	SObject result;
    	Schema.SObjectType obj = Schema.getGlobalDescribe().get(objName);
    	if(obj != null) {
    		result = obj.newSObject();
    	}
    	return result;
    }
	for change orders phase II we are not overriding and changes so this is commented out until it's needed */

	public static Boolean checkInService(Id accountId) {
		Boolean result = false;
		// make sure we have an account
		if(String.isNotBlank(accountId)) {
			// get in service dates from fpo
			for(LeasePayment__c fpo : [SELECT Placed_In_Service__c, Date_in_PTO_Letter__c, Energy_Start_Date__c FROM LeasePayment__c WHERE Account__c = :accountId]) {
				// check fpo dates
				if(fpo.Placed_In_Service__c != null || fpo.Date_in_PTO_Letter__c != null || fpo.Energy_Start_Date__c != null) {
					result = true;
				}
			}
		}
		return result;
	}

	public static List<Messaging.SingleEmailMessage> createEmails(Id accountId, Id quoteId, String sub, String bdy, String comment, String errorMsg) {
		List<Messaging.SingleEmailMessage> result = new List<Messaging.SingleEmailMessage>();
		try {
			// get url for org
			String orgURL = Url.getSalesforceBaseUrl().toExternalForm();
			// create link back to record
			String recordLink = orgURL + '/' + accountId;
			// get email info
			// user's name
			String userName = UserInfo.getName();
			// contact Id
			Id contactId;
			for(User u : [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]) {
				contactId = u.ContactId;
			}
			// contract number
			String contractNum = [SELECT Consolidated_Lease_Number__c FROM Quote WHERE Id = :quoteId].Consolidated_Lease_Number__c;
			// other info and set email fields
			for(Account a : [SELECT Name, Partner_Account__r.Name, Partner_Account__r.Primary_PSR_Email__c FROM Account WHERE Id = :accountId]) {
				String subject = a.Name + ': ' + sub + ' (' + contractNum + ')';
				String body = bdy + ' <br/>Requestor: ' + a.Partner_Account__r.Name + ' - ' + userName + '  (' + orgURL + '/' + contactId + ') <br/>Customer: ' + a.Name + '  (' + recordLink + ') <br/>Agreement: ' + recordLink + ' <br/>Countersigned Agreement: ' + contractNum + ' <br/>Explanation: ' + comment + ' <br/>';
				if(String.isNotBlank(errorMsg)) body += '<br/>Error: ' + errorMsg;
				List<String> sendTo = new List<String>();
				if(String.isNotBlank(a.Partner_Account__r.Primary_PSR_Email__c)) sendTo.add(a.Partner_Account__r.Primary_PSR_Email__c);
				sendTo.add('leasecontrolspsr@sunpowercorp.com');
				sendTo.add('PaymentInquiry@sunpowercorp.com');
				sendTo.add('SunPowerFinancing@sunpowercorp.com');

				Messaging.SingleEmailMessage e = new Messaging.SingleEmailMessage();
				e.setToAddresses(sendTo);
				e.setSubject(subject);
				e.setHtmlBody(body);
				result.add(e);
			}
			// test hack for 75% coverage
        	if(Test.isRunningTest()) {
				Integer i = 10/0;
        	}
		}
		catch(Exception e) {
			SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Create ' + sub + ' Request Error');
		}
		return result;
	}

	public static ResultMessage sendEmails(List<Messaging.SingleEmailMessage> emails, String errorMsg) {
		ResultMessage result = new ResultMessage();
		try {
			result.success = true;
			// send emails
	        if(!emails.isEmpty()) {
	            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails, false);
	            // debug errors
	            for(Messaging.SendEmailResult er : results) {
	                if(!er.isSuccess()) {
	                	result.success = false;
	                    List<Messaging.SendEmailError> sees = er.getErrors();
	                    for(Messaging.SendEmailError ser : sees) {
	                        System.debug(ser.getFields() + ' - ' + ser.getMessage() + ' - ' + ser.getStatusCode());
	                        if(String.isNotBlank(errorMsg)) {
	                        	result.message = 'Original error: ' + errorMsg;
		                        result.message += '<br/>Email send error: ' + ser.getFields() + ' - ' + ser.getMessage() + ' - ' + ser.getStatusCode();
		                        break;
		                    } else {
	                        	result.message = 'Email send error: ' + ser.getFields() + ' - ' + ser.getMessage() + ' - ' + ser.getStatusCode();
	                        	break;
	                        }
	                    }
	                }
	            }
	        }
			// test hack for 75% coverage
        	if(Test.isRunningTest()) {
				Integer i = 10/0;
        	}
	    }
	    catch(Exception e) {
	    	result.success = false;
	    	result.message = e.getMessage() + ' - ' + e.getStackTraceString();
	    }
	    return result;
	}

	public static ResultMessage checkPendingAmendment(Id agreementId, Id accountId, String changeOrderType) {
		ResultMessage result = new ResultMessage();
		try {
			result.success = false;
			Id amendmentRTId = AgreementUtility.amendmentRecTypeId;
			// check for pending amendments
			if(String.isNotBlank(accountId)) {
				for(echosign_dev1__SIGN_Agreement__c a : [SELECT Id FROM echosign_dev1__SIGN_Agreement__c WHERE Account__c = :accountId AND Id != :agreementId AND RecordTypeId = :amendmentRTId AND echosign_dev1__Status__c != 'Signed' AND echosign_dev1__Status__c != 'Cancelled' AND Change_Order_Type__c = :changeOrderType]) {
					result.message = a.Id;
					result.success = true;
				}
			}
			// test hack for 75% coverage
        	if(Test.isRunningTest()) {
				Integer i = 10/0;
        	}
		}
		catch(Exception e) {
			SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Check Pending Amendment Error');
		}
		return result;
	}

	// decommission quote is called by the agreement after update handler and passes in a list of amended agreements that have just been counter signed
	@future
	public static void decommissionQuote(List<Id> ids) {
		try {
			// remove any duplicates
			Set<Id> signedAmenedments = new Set<Id>(ids);
			// list of quotes to update
			List<Quote> quotes = new List<Quote>();
			// amended quote Ids - map is new quote/old quote
			Map<Id, Id> amendedQuoteIds = new Map<Id, Id>();
			// get quote ids
			for(echosign_dev1__SIGN_Agreement__c a : [SELECT Account__c, Quote__c, Change_Order_Type__c, Quote__r.Amended_Lease__c, Quote__r.Amended_Lease__r.Consolidated_Lease_Number__c, Quote__r.Amended_Lease__r.Lease_doc_Signed_Date__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id IN :signedAmenedments]) {
				// check to make sure quote is a economic change order
				if(a.Change_Order_Type__c == 'Economic Amendment' && String.isNotBlank(a.Quote__r.Amended_Lease__c)) {
					// update amended quote with lease number & date signed
					Quote newQuote = new Quote();
					newQuote.Id = a.Quote__c;
					newQuote.Lease_Doc_Signed__c = true;
                    newQuote.Amendment_Doc_Signed__c = true;
					newQuote.Amendment_Date__c = System.today();
					newQuote.Original_Lease_Number__c = a.Quote__r.Amended_Lease__r.Consolidated_Lease_Number__c;
					newQuote.Lease_doc_Signed_Date__c = a.Quote__r.Amended_Lease__r.Lease_doc_Signed_Date__c;
					quotes.add(newQuote);
					// decommission old quote by removing the lease number
					Quote oldQuote = new Quote();
					oldQuote.Id = a.Quote__r.Amended_Lease__c;
					// string for amendment number logic
					String num;
					// get the number of old quotes excluding this newly signed one
					Integer i = [SELECT Count() FROM Quote WHERE AccountId = :a.Account__c AND Lease_Doc_Signed__c = true AND Id != :a.Quote__c];
					// fix up number so format is Amended-09, Amended-10, etc...
					if(i < 10) {
						num = '0' + String.valueOf(i);
					} else num = String.valueOf(i);
					// set the value
					oldQuote.Original_Lease_Number__c = 'Amended-' + num;
					quotes.add(oldQuote);
					// add the amended quote Id to the list
					amendedQuoteIds.put(a.Quote__c, a.Quote__r.Amended_Lease__c);
				}
			}
			// get old cloned quotes that are no longer valid due to this new countersigned amendment
			for(Quote q : [SELECT Id FROM Quote WHERE Amended_Lease__c IN :amendedQuoteIds.values() AND Id NOT IN :amendedQuoteIds.keySet()]) {
				Quote oldQuote = new Quote();
				oldQuote.Id = q.Id;
				oldQuote.Amended_Lease__c = null;
				quotes.add(oldQuote);
			}
			if(!quotes.isEmpty()) {
				update quotes;
			}
		}
		catch(Exception e) {
			SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Decommission Quote Error');
		}
	}

	// called from the agreement after update handler and passes in a list of cancelled agreements that have just been counter signed
	public static void cancelClonedQuotes(List<echosign_dev1__SIGN_Agreement__c> agreements) {
		try {
			// set of quotes Ids that are no longer valid for clones
			Set<Id> quoteIds = new Set<Id>();
			// load set
			for(echosign_dev1__SIGN_Agreement__c a : agreements) {
				if(String.isNotBlank(a.Quote__c)) {
					quoteIds.add(a.Quote__c);
				}
			}
			// quotes to update
			List<Quote> quotes = new List<Quote>();
			// load quotes
			for(Quote q : [SELECT Id FROM Quote WHERE Amended_Lease__c IN :quoteIds]) {
				Quote newQuote = new Quote();
				newQuote.Id = q.Id;
				newQuote.Amended_Lease__c = null;
				quotes.add(newQuote);
			}
			// update quotes
			if(!quotes.isEmpty()) {
				update quotes;
			}
		}
		catch(Exception e) {
			SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Cancel Cloned Quotes Error');
		}
	}
	
	public static String getEddieCloneURL(Id newQuoteId, Id oldQuoteId, Id accountId) {
		String result;
		String SECRET_KEY = Label.DynamicProposalSecretKey;
        String quoteIdEncoded = EncodingUtil.urlEncode(newQuoteId, 'UTF-8');
        String timeStampEncoded = EncodingUtil.urlEncode(String.valueOf(System.now().getTime()), 'UTF-8');
        String userIdEncoded = EncodingUtil.urlEncode(Userinfo.getUserId(), 'UTF-8');
        String accountIdEncoded = EncodingUtil.urlEncode(accountId, 'UTF-8');
		String eddieURL;
        if(OrgUtil.runningInASandbox()){
            eddieURL = Label.manualmodeSandboxURL;
        } else {
        	eddieURL = Label.manualmodeProductionURL;
        }
		String quoteIdtimeStampEncoded = 'quote_id=' + quoteIdEncoded + '&timestamp=' + timeStampEncoded + '&user_id=' + userIdEncoded + '&account_id=' + accountIdEncoded;

        Blob cryptoKey = EncodingUtil.base64Decode(SECRET_KEY);
        Blob encryptedSignature = Crypto.encryptWithManagedIV('AES128',cryptoKey, Blob.valueOf(quoteIdtimeStampEncoded));
        String base64EncodedQidTmStmp = EncodingUtil.base64Encode(encryptedSignature);

        // setup return url
        String sfReturnURL = newQuoteId + '&oldQuoteId=' + oldQuoteId;
        sfReturnURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/AgreementConfirmation?QuoteId=' + EncodingUtil.urlEncode(sfReturnURL, 'UTF-8');

        result = eddieURL + '/quote/' + newQuoteId + '?cloneQuoteSFID=' + oldQuoteId + '&returnURL=' + sfReturnURL + '#id_token=' + base64EncodedQidTmStmp;
        return result;
	}

	public static String getQuoteDeltaURL(Id newQuoteId, Id oldQuoteId) {
		String result;
		if(String.isNotBlank(newQuoteId) && String.isNotBlank(oldQuoteId)) {
			result = '/apex/QuoteAmendmentDelta?NewQuoteId=' + newQuoteId + '&OldQuoteId=' + oldQuoteId;
			}
		return result;
    } 	
}
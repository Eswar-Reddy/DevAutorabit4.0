@RestResource(urlMapping='/MultiDocUpload/v1/*')
global with sharing class REST_DocUploader {

	private static Id docId {get;set;}
    @TestVisible
    private static Boolean dmlSuccess {get;set;}

    @HttpPost
    global static void attachDoc() {

        RestRequest req = RestContext.request;
        String msg = processRequest(req);

        Restcontext.response.responseBody = Blob.valueOf(msg);

    }

    public static String processRequest(RestRequest req) {

        String fName = req.params.get('FileName');
        System.debug('fName: ' + fName);
        String parId = req.params.get('parentIds');
        System.debug('parId: ' + parId);
        Boolean attachmentOnly = Boolean.valueOf(req.params.get('attachmentOnly'));
        System.debug('attachmentOnly: ' + attachmentOnly);

        String res = '';

        if(req.requestBody.size() > 25000000) {
            res = buildResponse(415, 'The maximum file size that you may upload is 25MB. Please compress your file, if you are exceeding this limit.', false);
            return res;
        }

        if(attachmentOnly) {
        	res = insertAttachment(parId, req.requestBody, fName); //return response body
        	return res;
        }
        else {
        	List<String> parentIds = parId.split(',');//NOT WORKING :(
        	res = createDocumentAssociation(parentIds, fName);
        	

        	if(dmlSuccess == false)
        		return res;
        	
        	else {
        		try {	        		
	        		res = insertAttachment(docId, req.requestBody, fName);
	        		return res;
	        	} catch(Exception e) {
	        		res = buildResponse(500, (e.getMessage() + ' ' + e.getStackTraceString()), false);
                    return res;
	        	}
        	}
        }      
   }

   	private static String insertAttachment(String parentId, Blob body, String name) {

   		System.debug('inserting attachment');
   		Attachment a = new Attachment (ParentId = parentId,
                                       Body = body,
                                       Name = name);

        try {
        	Database.SaveResult result = Database.insert(a);
        	System.debug('ATTACHMENT DML SUCCESSFUL ' + result.getId());
        	
        	return buildResponse(200, result.getId(), true);
    	} catch(Exception e) {
    		System.debug(LoggingLevel.ERROR, 'ATTACHMENT DML ERROR: ' + e);
    		return buildResponse(400, (e.getMessage() + ' ' + e.getStackTraceString()), false);
    	}
        
   	}

   	private static String createDocumentAssociation(List<String> parentIds, String fileName) {

        Document__c d = new Document__c();
        d.Name = fileName;
        dmlSuccess = false;

        Map<String, Schema.SObjectType> idToObjectType = new Map<String, Schema.SObjectType>();
            
        for(String s : parentIds) {    
            try {
                Id i = (Id)s;
                idToObjectType.put(s, i.getSObjectType());
            } catch(Exception e) {
                System.debug(LoggingLevel.ERROR, 'Invalid Id: ' + s);
            }
        }

        if(idToObjectType.isEmpty()) {
        	return buildResponse(204, 'NO VALID IDS', false);
        }

        Schema.DescribeSObjectResult objResult = Document__c.SObjectType.getDescribe();
        List<Schema.SObjectField> fields = objResult.fields.getMap().values();
        for(Schema.SObjectField f : fields) {
            Schema.DescribeFieldResult r = f.getDescribe();
            if(!r.getReferenceTo().isEmpty()) {
                for(String s : idToObjectType.keyset()) {
                    for(Schema.SObjectType t : r.getReferenceTo()) {
                        if(t == idToObjectType.get(s)) {
                            System.debug('MATCH! ' + r);
                            d.put(String.valueOf(r.getsObjectField()),s) ;
                        }                
                    }
                }
            }
        }
        
        try {
            Database.SaveResult result = Database.insert(d);
            System.debug('DOCUMENT DML SUCCESSFUL ' + result.getId());
            dmlSuccess = true;
            docId = result.getId();
            
            return buildResponse(200, result.getId(), true);
        } catch(Exception e) {
         	System.debug(LoggingLevel.ERROR, 'DOCUMENT DML EXCEPTION: ' + e);
            
            return buildResponse(400, (e.getMessage() + ' ' + e.getStackTraceString()), false);
        }
    }

    private static String buildResponse(Integer statusCode, String result, Boolean isSuccess) {

        JSONGenerator jsonResponse = JSON.createGenerator(false);
        jsonResponse.writeStartObject();
        jsonResponse.writeBooleanField('success', isSuccess);
        if(statusCode != null)
            jsonResponse.writeNumberField('statusCode', statusCode);
        if(result != null)
            jsonResponse.writeStringField('result', result);
        
        return jsonResponse.getAsString();
    }

}
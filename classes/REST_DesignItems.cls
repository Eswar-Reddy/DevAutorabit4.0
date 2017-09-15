@RestResource(urlMapping = '/RESTDesignItems/v1/*')

// Rest API to upsert DesignItems
global without sharing class REST_DesignItems {

    global class DesignInfo {
        public Decimal SystemSize;
        public Decimal ModuleNumber;
        public String  ModuleName;
        public String  UserFirstName;
        public String  UserLastName;
        public String  UserEmail;
        public String  RoleName;
        public String  SpecializedSeller;
        public String  DesignName;
    }

    // Response Code
    private static final String RESULT_SUCCESS = '000';
    private static final String RESULT_PARSE_ERROR = '001';
    private static final String RESULT_NO_DATA = '002';
    private static final String RESULT_DATA_ERROR = '003';
    private static final String NO_DESIGN_ID = 'NoID';

    private static Integer numOfObj = 0;
    private static String result    = '';
    private static String message   = '';

    @HttpGet
    global static void getDesign() {
        // CustomerInformation cWC;
        RestRequest req = RestContext.request;
        try {
            if (String.isNotBlank(req.params.get('DId'))) {
                DesignInfo design = getDesignInfo(req.params.get('DId'));
                result = RESULT_SUCCESS;
                message = JSON.serialize(design);
            } else {
                result = RESULT_DATA_ERROR;
                message += 'No SunPower Design Id';
            }
        } catch (Exception e) {
            result = RESULT_DATA_ERROR;
            message += e.getMessage() + ' StackTrace: ' + e.getStackTraceString();
        }

        RestContext.response.responseBody = createResponse();
    }

    @HttpPost
    global static void updateRecords() {
        RestRequest req = RestContext.request;
        String jsonString = EncodingUtil.urlDecode(req.requestBody.toString(), 'UTF-8');
        processObjects(parseString(jsonString));
        RestContext.response.responseBody = createResponse();
    }

    private static DesignInfo getDesignInfo(String xDId) {

        DesignInfo design = new DesignInfo();

        design.UserFirstName = UserInfo.getFirstName();
        design.UserLastName = UserInfo.getLastName();
        design.UserEmail = UserInfo.getUserEmail();
        
        system.debug('UserInfo.getUserRoleId() ============>'+UserInfo.getUserRoleId()+'==xDId==>'+xDId);
        
        if(UserInfo.getUserRoleId() != null){
        	UserRole role = [SELECT Name FROM UserRole WHERE Id = :UserInfo.getUserRoleId()];
        	design.RoleName = role.Name;
        }
		
		User objUser = [Select u.Contact.FirstName, u.Contact.LastName, u.Contact.Account.Specialized_Seller__c, u.ContactId From User u where id =: UserInfo.getUserId()];
            
        if(objUser.Contact !=null && objUser.Contact.Account !=null && objUser.Contact.Account.Specialized_Seller__c != null){
        	design.SpecializedSeller = objUser.Contact.Account.Specialized_Seller__c;
        	system.debug('**** design.SpecializedSeller ***'+design.SpecializedSeller);
        }
        else 
        	design.SpecializedSeller = '';
		
        if (!xDId.equals(NO_DESIGN_ID)) {
            SunPower_Design__c d = [SELECT Name,system_size__c FROM SunPower_Design__c WHERE id = :xDId];
            SunPower_Design_Item__c item = [SELECT Name,Quantity__c FROM SunPower_Design_Item__c WHERE SunPower_Design__c = :xDId AND Component_Type__c = 'Module' LIMIT 1];
            design.SystemSize = d.system_size__c;
            design.ModuleNumber = item.Quantity__c;
            
            //Case #00496724 
            design.ModuleName = item.Name;
            design.DesignName = d.Name;	
        }
        return design;
    }

    // process input json and then return a list of objects
    public static List<sObject> parseString(String jsonString) {

        // parse the string and find out fields, make sure all fields are coming out from
        // DescribeSObjectResult
        List<sObject> lstObj = new List<sObject>();
        sObject currObj;

        try {
            Schema.sObjectType objectDef;
            //find all the fields for this object type
            Map<String, Schema.SobjectField> mapFields;

            JSONParser parser = JSON.createParser(jsonString);
            Map<Integer, Map<String, Object>> jsonValueMap = new Map<Integer, Map<String, Object>>();
            Boolean isArray = false;
            Boolean isStart = false;
            String objString = '';
            String clsName;

            //Map to hold innerObject Names based on position in the jsonObject
            Map<Integer, String> jsonInnerObjectMap = new Map<Integer, String>();
            //Counter to hold depth of jsonObject
            Integer beginCount = 0;
            Integer recCount = 0;

            while (parser.nextToken() != null) {
                String currentField = parser.getCurrentName();
                JSONToken currentToken = parser.getCurrentToken();
                String jsonObject = null;
                if (currentToken == JSONtoken.START_ARRAY) {
                    isArray = true;
                } else if (currentToken == JSONtoken.END_ARRAY) {
                    isArray = false;
                }
                if (isArray == false ) {
                    if (currentToken == JSONToken.FIELD_NAME &&
                            currentField.toLowerCase() == 'objecttype') {
                        currentToken = parser.nextToken();
                        clsName = parser.getText();
                        objectDef = Schema.getGlobalDescribe().get(clsName).getDescribe().getSObjectType();
                        //find all the fields for this object type
                        mapFields = objectDef.getDescribe().fields.getMap();
                        System.debug('mapFields: ' + mapFields);

                    }
                    continue;
                }
                if (currentToken == JSONToken.START_OBJECT) {
                    //jsonObject = currentField;
                    recCount++;
                    jsonValueMap.put(recCount, new Map<String, Object>());
                    isStart = true;
                    objString = parser.getText();
                } else if (currentToken == JSONToken.END_OBJECT) {

                    objString += parser.getText();
                    System.debug('objString: ' + objString);

                    // currObj = (sobject)json.deserialize(objString, SunPower_Design_Item__c.class);
                    currObj = (sobject)JSON.deserialize(objString, Type.forName(clsName));
                    //currObj = objectDef.newSObject();
                    lstObj.add(currObj);

                } else if (currentToken == JSONToken.FIELD_NAME) {

                    // construct the JSON string for this object
                    if (isStart == true) {
                        objString += '"' + parser.getText() + '"' + ':';
                    } else {
                        objString += ',"' + parser.getText() + '"' + ':';

                    }
                    parser.nextToken();
                    objString += '"' + parser.getText() + '"';

                    isStart = false;

                }
            }

        } catch (Exception e) {
            message += e.getMessage() + ' StackTrace: ' + e.getStackTraceString();
            result = RESULT_PARSE_ERROR;

        }
        System.debug('lstObj: ' + lstObj);
        return lstObj;
    }

    private static void processObjects(List<sObject> lstObj) {

        if (lstObj.size() == 0) {
            message += 'No BOM item received in the payload';
            result = RESULT_NO_DATA;
            numOfObj = 0;
            return;
        }

        try {
            List<SunPower_Design_Item__c> lstItem = new List<SunPower_Design_Item__c>();
            Set<ID> setDesign = new Set<ID>();

            // Map<OracleID, sfdcID>
            Map<String, String> mapOracle = new Map<String, String>();

            for ( sObject o : lstObj) {
                SunPower_Design_Item__c item = (SunPower_Design_Item__c)o;

                // Just to create the key sets here:
                mapOracle.put(item.Item_ID__c, '');
                lstItem.add(item);
                setDesign.add(item.SunPower_Design__c);
            }

            // Find all the items
            Map<Id, Item__c> mapItem = new Map<Id, Item__c>([SELECT Id, Item_ID__c FROM Item__c WHERE Item_ID__c IN :mapOracle.keySet()]);

            for (String sfId : mapItem.keySet()) {
                mapOracle.put(mapItem.get(sfId).Item_ID__c, sfId);
            }

            System.debug('mapOracle: ' + mapOracle);

            // Replace the oracle Id in the Json object with the Item__d Id in SFDC
            for (SunPower_Design_Item__c item : lstItem) {
                if (mapOracle.containsKey(item.Item_ID__c)) {
                    item.Oracle_Item_ID__c = mapOracle.get(item.Item_ID__c);
                } else {
                    message += ' Item_ID__c : ' + item.Item_ID__c + ' does not exist';
                    result = RESULT_DATA_ERROR;
                    return;
                }
            }

            // Update the Design Status to 'Complete'
            List<SunPower_Design__c> lstDesign = new List<SunPower_Design__c>();
            for (Id sd : setDesign) {
                lstDesign.add(new SunPower_Design__c(Id = sd, Design_Status__c = 'Complete'));
            }

            if (lstItem.size() > 0 ) {
                insert lstItem;
            }

            if (lstDesign.size() > 0) {
                update lstDesign;
            }

            numOfObj = lstItem.size();
            message += 'Success!';
            result = RESULT_SUCCESS;

        } catch ( Exception e) {
            message += e.getMessage() + ' StackTrace: ' + e.getStackTraceString();
            result = RESULT_DATA_ERROR;
        }
    }

    private static Blob createResponse() {

        JSONGenerator responseJson = Json.createGenerator(true);
        responseJson.writeStartObject();
        responseJson.writeFieldName('responses');
        responseJson.writeStartArray();

        responseJson.writeStartObject();
        responseJson.writeStringField('result', result);
        responseJson.writeEndObject();
        // createDebugLogs(wrappers);

        responseJson.writeStartObject();
        responseJson.writeStringField('numOfObj', String.valueOf(numOfObj));
        responseJson.writeEndObject();

        responseJson.writeStartObject();
        responseJson.writeStringField('message', message);
        responseJson.writeEndObject();

        responseJson.writeEndArray();
        responseJson.writeEndObject();
        System.debug(responseJson.getAsString());

        return Blob.valueOf(responseJson.getAsString());
    }
 
}
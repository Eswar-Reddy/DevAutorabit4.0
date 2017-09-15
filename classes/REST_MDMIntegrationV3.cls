@RestResource(urlMapping = '/REST_CustomerIntegration/v1/*')

/*
/services/apexrest/REST_CustomerIntegration/v1/*
{

  "ObjectType": "Account",
  "ObjectList": [
    {
      "Action": "Insert",
      "AccountFirstName": "Sam",
      "AccountLastName": "Chakkanat",
      "ExternalSourceId": "111111",
      "ExternalSourceName": "SMS",
      "PartnerId": "0018000000UqM8i",
      "RecordType": "Residential Customer",
      "TransactionType": "Cash",
      "IsCustomer": "True",
      "ContactEmail": "kevin.huang@test.com",
      "ContactPhone": "480-111-1111",
      "BillingStreet": "838 Blossom Hill Rd",
      "BillingCity": "San Jose",
      "BillingState": "CA",
      "BillingPostalCode": "95123",
      "BillingCountry": "United States",
      "CurrencyIsoCode": "USD"
    }
  ]
}


*/

// Rest API to upsert DesignItems
global without sharing class REST_MDMIntegrationV3 {

    global class DesignInfo {
        public Decimal SystemSize;
        public Decimal ModuleNumber;
        public String  UserFirstName;
        public String  UserLastName;
        public String  UserEmail;
        public String  RoleName;
    }

    global class ResponseWrapper {
        public String AccountId;
        public String SMS_Id;
        public String Street;
        public String City;
        public String ZipCode;
        public String State;
        public String Country;
        public String Lat;
        public String Lon;
        public String Action;
    }

    global class ObjectWrapper {
        public String objType = null;
        public String jsonString = '';
        public Map<String, String> mapProperty = new Map<String, String>();
    }

    // CONSTANT
    private static final String OBJ_TYPE = 'objecttype';

    private static final String ACTION_DUP_UPDATE = 'Duplicate Update with external Bean';
    private static final String ACTION_DUP_NO_UPDATE = 'Duplicate found, no update';
    private static final String ACTION_INSERT = 'Insert';
    private static final String ACTION_UPDATE = 'Update';

    private static final String ACTION_ADDRESS_NOT_FOUND = 'No Action, Address Not Found';
    private static final String ACTION_NO_PARTNER = 'No Action, No Partner Id';
    private static final String ACTION_NO_ACCOUT_ID = 'No Update, Account Id is not found';

    // Response Code
    private static final String RESULT_SUCCESS = '000';
    private static final String RESULT_PARSE_ERROR = '001';
    private static final String RESULT_NO_DATA = '002';
    private static final String RESULT_DATA_ERROR = '003';

    private static Integer numOfObj = 0;
    private static String result    = '';
    private static String message   = '';
    private static List<ResponseWrapper> lstRes = new List<ResponseWrapper>();
    private static List<sObject> lstInsert = new List<sObject>();
    private static List<sObject> lstUpdate = new List<sObject>();


    private static Util_Payload payloadUtil;

    private static void resetStatus() {
        numOfObj = 0;
        result    = '';
        message   = '';
    }

    @HttpPost
    global static void updateRecords() {

        //System.savepoint sp = Database.setSavepoint();

        resetStatus();

        RestRequest req = RestContext.request;
        String jsonString = EncodingUtil.urlDecode(req.requestBody.toString(), 'UTF-8');

        List<ObjectWrapper> lstObj = parseString(jsonString);

        if (result == '') {
            processObjects(lstObj);
        }
        RestContext.response.responseBody = createResponse();

        //Database.rollback(sp);
    }

    // process input json and then return a list of objects
    public static List<ObjectWrapper> parseString(String jsonString) {
        
        System.debug('jsonString ----- '+jsonString);
        // parse the string and find out fields, make sure all fields are coming out from
        // DescribeSObjectResult
        List<ObjectWrapper> lstObj = new List<ObjectWrapper>();
        ObjectWrapper currObj;
        String objString = '';
        Type   objType;

        try {
            Schema.sObjectType objectDef;
            //find all the fields for this object type
            Map<String, Schema.SobjectField> mapFields;

            JSONParser parser = JSON.createParser(jsonString);
            System.debug('parser -----'+parser);
            Map<Integer, Map<String, Object>> jsonValueMap = new Map<Integer, Map<String, Object>>();
            Boolean isArray = false;
            Boolean isStart = false;
            String clsName  = null;
            String objName  = null;

            //Map to hold innerObject Names based on position in the jsonObject
            Map<Integer, String> jsonInnerObjectMap = new Map<Integer, String>();
            //Counter to hold depth of jsonObject
            Integer beginCount = 0;
            Integer recCount = 0;

            while (parser.nextToken() != null) {
                String currentField = parser.getCurrentName();
                JSONToken currentToken = parser.getCurrentToken();
                String jsonObject = null;
                System.debug('currentToken ----- '+currentToken+'     equalsnotequals-----'+JSONtoken.START_ARRAY);
                if (currentToken == JSONtoken.START_ARRAY) {
                    isArray = true;
                } else if (currentToken == JSONtoken.END_ARRAY) {
                    isArray = false;
                }
                if (isArray == false ) {

                    // If the array has the same OBJ_TYPE
                    if (currentToken == JSONToken.FIELD_NAME &&
                            currentField.toLowerCase() == OBJ_TYPE) {
                        currentToken = parser.nextToken();
                        clsName = parser.getText();
                    }
                    continue;
                }
                if (currentToken == JSONToken.START_OBJECT) {
                    //jsonObject = currentField;
                    recCount++;
                    jsonValueMap.put(recCount, new Map<String, Object>());
                    isStart = true;
                    currObj = new ObjectWrapper();
                    currObj.jsonString = parser.getText();
                } else if (currentToken == JSONToken.END_OBJECT) {

                    // remove the last ',' in the jsonString
                    currObj.jsonString = currObj.jsonString.substring(0, currObj.jsonString.length() - 1);
                    currObj.jsonString += parser.getText();
                    System.debug('objString: ' + currObj.jsonString);
                    lstObj.add(currObj);

                } else if (currentToken == JSONToken.FIELD_NAME) {

                    // construct the JSON string for this object
                    String fName = parser.getText();
                    parser.nextToken();
                    String fValue = parser.getText();

                    if (isStart == true) {
                        currObj.objType = clsName;

                        if (currObj.objType == null) {
                            if (fName.toLowerCase() != OBJ_TYPE) {
                                message += 'no object type in the payload';
                                result = RESULT_PARSE_ERROR;
                                return lstObj;
                            } else {
                                currObj.objType = fValue;
                            }
                        }

                        isStart = false;
                    }
                    currObj.mapProperty.put(fName, fValue);

                }
            }

        } catch (Exception e) {
            message += 'obj: ' + currObj.jsonString + '; ' + 'objType: ' + currObj.objType
                       + ' eMsg: ' + e.getMessage() + ' eCause: ' + e.getCause()
                       + ' StackTrace: ' + e.getStackTraceString();
            result = RESULT_PARSE_ERROR;

        }
        System.debug('lstObj: ' + lstObj);
        return lstObj;
    }

    private static void processObjects(List<ObjectWrapper> lstObj) {

        // No objects are parsed
        if (lstObj.size() == 0) {
            message += 'No Account received in the payload';
            result = RESULT_NO_DATA;
            numOfObj = 0;
            return;
        }

        try {

            payloadUtil = new Util_Payload('MDM');

            for ( ObjectWrapper o : lstObj) {

                Map<String, PayloadSettings__c> mapJSON_Field = payloadUtil.sObjectFieldMap.get(o.objType);

                if (mapJSON_Field == null) {
                    // ObjectType is not found in the custom setting
                    message += o.objType + ' is not a valid ObjectType';
                    result = RESULT_NO_DATA;
                    numOfObj = 0;
                    return;
                }

                // Create JSON string to hold the object
                String jsonString = '{';
                String action = o.mapProperty.get('Action');

                // Loop through all the SFDC fields in the custom setting for this Object
                for (String j : o.mapProperty.keySet()) {

                    // The JSON field in the custom setting is not present in the payload
                    if (mapJSON_Field.get(j) != null) {
                        if ( Util_Payload.hasAction(action, mapJSON_Field.get(j)) ) {
                            // build the JSON string for this object
                            jsonString += '"' + mapJSON_Field.get(j).Field_API_Name__c + '"' + ':' + '"' + o.mapProperty.get(j) + '",';
                        }
                    }
                }
                jsonString = jsonString.substring(0, jsonString.length() - 1);
                jsonString += '}';

                // deserialize the object from the JSON string
                sObject sObj = (sObject)JSON.deserialize(jsonString, Type.forName(o.objType));

                // postProcessing the object
                if (o.objType.equals('Account')) {
                    Account a = (Account)sObj;

                    if (action.equals(ACTION_INSERT)) {
                        insertAccount(o, a);

                    } else if (action.equals(ACTION_UPDATE)) {
                        updateAccount(o, a);
                    }
                } else {
                    if (action.equals(ACTION_INSERT)) {
                        lstInsert.add(sObj);

                    } else if (action.equals(ACTION_UPDATE)) {
                        lstUpdate.add(sObj);
                    }
                }
                numOfObj++;
            }

            if (lstInsert.size() > 0 ) {
                insert lstInsert;
            }

            if (lstUpdate.size() > 0) {
                update lstUpdate;
            }

            message += 'Success!';
            result = RESULT_SUCCESS;

        } catch ( Exception e) {
            message += e.getMessage() + ' StackTrace: ' + e.getStackTraceString() + ' jsonString: ' + lstObj[0].jsonString;
            result = RESULT_DATA_ERROR;
        }
    }

    private static Blob createResponse() {

        JSONGenerator responseJson = Json.createGenerator(true);
        responseJson.writeStartObject();

        responseJson.writeStringField('result', result);
        responseJson.writeStringField('numOfObj', String.valueOf(numOfObj));
        responseJson.writeStringField('message', message);
        responseJson.writeStringField('response', JSON.serialize(lstRes));

        responseJson.writeEndObject();
        System.debug(responseJson.getAsString());

        return Blob.valueOf(responseJson.getAsString());
    }

    private static void updateAccount(ObjectWrapper o, Account a) {

        ResponseWrapper rw = new ResponseWrapper();

        Account[] a2 = [SELECT DSE_IsCustomer__c, DSE__DS_Synchronize__c, Lat__c, Log__c, RecordTypeId, Name,
                        BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Id = :a.Id LIMIT 1];

        System.debug('------ a2: ' + a2 + 'a2.size(): ' + a2.size());

        // No account with this ID
        if (a2.size() > 0 ) {
            // DSE_Site__c is consist of the following information
            //
            a = a2[0];
            a.DSE_Site__c = generateDSE_Site(o, a);
            //CD
            a.IsExcludedFromRealign = true;
            // all other information we want to update can be updated here
            update a;

        } else {
            // Error, no Account found
            setResponseWrapper(rw, a, o);
            rw.Action = ACTION_NO_ACCOUT_ID;
            lstRes.add(rw);
            return;
        }

        // create external bean
        DSE__DS_Bean__c bean = createExternalBean(o, a);
        lstInsert.add(bean);

        setResponseWrapper(rw, a, o);
        rw.Action = ACTION_UPDATE;

        lstRes.add(rw);

    }

    private static void insertAccount(ObjectWrapper o, Account a) {

        ResponseWrapper rw = new ResponseWrapper();
        a.Name = o.mapProperty.get('AccountLastName') + ',' + o.mapProperty.get('AccountFirstName');
        if (a.Partner_Account__c == null) {
            setResponseWrapper(rw, a, o);
            rw.Action = ACTION_NO_PARTNER;
            return;
        }

        // Get geo information from google
        String cleanAddress =
            GeocodeAsyncHandler.cleanAddress(a.BillingStreet, a.BillingCity, a.BillingState, a.BillingPostalCode, a.BillingCountry);
        GeocodeAsyncHandler.GeoInfo gInfo = GeocodeAsyncHandler.GeoCode(cleanAddress);

        // address is not found
        if (!gInfo.AddressFound) {
            setResponseWrapper(rw, a, o);
            rw.Action = ACTION_ADDRESS_NOT_FOUND;
            return;
        }
        // get standard address
        system.debug('gInfo:' + gInfo);
        String[] standAddr = gInfo.fAddress.split(',', 2);
        a.BillingStreet = standAddr[0];

        // KHDebug
        // message += JSON.serialize(gInfo);

        // Email from Sri Goparaju :
        // While checking for the duplicates in salesforce for the new data that is coming from SMS,
        // we need to check for the address and the partner match. I believe
        // we shouldn't check the customer name as the name that will be entered
        // in the SMS portal might not be an exact match with the one in the sales force.
        Account[] a2 = [SELECT DSE_IsCustomer__c, DSE__DS_Synchronize__c, RecordTypeId, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                        FROM Account WHERE
                        Partner_Account__c = :a.Partner_Account__c AND BillingStreet = :a.BillingStreet
                                             AND BillingCity = :a.BillingCity AND BillingState = :a.BillingState
                                                     AND BillingPostalCode = :a.BillingPostalCode AND BillingCountry = :a.BillingCountry
                                                             LIMIT 1];

        // Found duplicate
        if (a2.size() > 0) {

            System.debug('------ duplicate found: ' + a2[0]);
            // if the IsCustomer is already true, don't update the account.DSE_CustomerType__c
            if (!a2[0].DSE_IsCustomer__c) {

                a2[0].DSE_CustomerType__c = a.DSE_CustomerType__c;
                a = a2[0];
                a.DSE_IsCustomer__c = true;
                a.DSE__DS_Synchronize__c = true;
                a.DSE_Site__c = generateDSE_Site(o, a);

                // update the type to the value from the payload
                lstUpdate.add(a);
                rw.Action = ACTION_DUP_UPDATE;
            } else {
                a = a2[0];
                rw.Action = ACTION_DUP_NO_UPDATE;
            }
        } else {

            // set the owner to the partner primary cecipient
            Account partner = [SELECT Opportunity_Recipient__c FROM Account WHERE Id = :a.Partner_Account__c];
            a.OwnerId = partner.Opportunity_Recipient__c;

            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                             get(o.mapProperty.get('RecordType')).getRecordTypeId();

            // DSE_Site__c is consist of the following information
            //
            a.Lat__c = gInfo.lat;
            a.Log__c = gInfo.lon;
            a.DSE_Site__c = generateDSE_Site(o, a);

            rw.Lat = String.valueOf(gInfo.lat);
            rw.Lon = String.valueOf(gInfo.lon);

            a.DSE__DS_Synchronize__c = true;
            //a.Oracle_County__c = gInfo.County;
            System.debug('------- a.ShippingPostalCode : ' + a.BillingPostalCode);
            
            a.Oracle_County__c = [SELECT id, Geo_County__c FROM Vertex_Address_Validation__c WHERE Geo_Postal_Code__c = :a.BillingPostalCode LIMIT 1].Geo_County__c;

            a.ShippingStreet = a.BillingStreet;
            a.ShippingCity   = a.BillingCity;
            a.ShippingState  = a.BillingState;
            a.ShippingPostalCode = a.BillingPostalCode;
            a.ShippingCountry = a.BillingCountry;
            a.Oracle_Shipping_County__c = a.Oracle_County__c;
            //CD
            a.IsExcludedFromRealign = true;
            insert a;

            // Create contact
            Contact c = new Contact();
            c.AccountId = a.Id;
            c.FirstName = o.mapProperty.get('AccountFirstName');
            c.LastName  = o.mapProperty.get('AccountLastName');
            // email and phone number might need update later from SMS
            // without the following infomation the survey does not go through
            c.Email = o.mapProperty.get('ContactEmail');
            c.Phone = o.mapProperty.get('ContactPhone');

            c.MailingStreet = a.BillingStreet;
            c.MailingCity   = a.BillingCity;
            c.MailingState  = a.BillingState;
            c.MailingPostalCode = a.BillingPostalCode;
            c.MailingCountry = a.BillingCountry;
            lstInsert.add(c);

            rw.Action = ACTION_INSERT;
        }

        // create external bean
        if (! rw.Action.equals(ACTION_DUP_NO_UPDATE)) {
            DSE__DS_Bean__c bean = createExternalBean(o, a);
            lstInsert.add(bean);
        }

        setResponseWrapper(rw, a, o);
        lstRes.add(rw);

    }

    private static DSE__DS_Bean__c createExternalBean(ObjectWrapper o, Account a) {
        // create external bean
        DSE__DS_Bean__c bean = new DSE__DS_Bean__c();
        System.debug('----- a: ' + a);

        // Based on Sri's comment that MDM will use this information to update the bean, that is not intended
        //bean.DSE__DS_Account__c = a.Id;
        bean.DSE__DS_Master_Bean__c = [SELECT Id FROM DSE__DS_Master_Bean__c WHERE DSE__DS_Account__c = :a.Id LIMIT 1].Id;
        bean.DSE__DS_Source_No__c = o.mapProperty.get('ExternalSourceId');
        bean.DSE__DS_Source__c = o.mapProperty.get('ExternalSourceName');
        bean.DSE__DS_Object_Class__c = o.objType;
        bean.DSE__DS_Custom_Field_8__c = o.mapProperty.get('ExternalSourceId');
        bean.DSE__DS_Custom_Field_10__c = Schema.SObjectType.Account.getRecordTypeInfosById().get(a.RecordTypeId).getName();
        bean.DSE__DS_Billing_Street__c = a.BillingStreet;
        bean.DSE__DS_Billing_City__c = a.BillingCity;
        bean.DSE__DS_Billing_State__c = a.BillingState;
        bean.DSE__DS_Billing_Postal_Code__c = a.BillingPostalCode;
        bean.DSE__DS_Billing_Country__c = a.BillingCountry;
        bean.DSE__DS_Company__c = a.Name;

        return bean;
    }

    private static String generateDSE_Site(ObjectWrapper o, Account a) {
        return ( o.mapProperty.get('ExternalSourceId') + '|'
                 + a.BillingStreet + '|'
                 + a.BillingStreet + '|'
                 + a.BillingCity + '|'
                 + a.BillingState + '|'
                 + a.BillingPostalCode + '|'
                 + a.BillingCountry + '|'
                 + a.Lat__c + '|' + a.Log__c );

    }

    private static void setResponseWrapper(ResponseWrapper rw, Account a, ObjectWrapper o) {
        rw.AccountId = a.Id;
        rw.SMS_Id = o.mapProperty.get('ExternalSourceId');
        rw.Street = a.BillingStreet;
        rw.City   = a.BillingCity;
        rw.State  = a.BillingState;
        rw.ZipCode = a.BillingPostalCode;
        rw.Country = a.BillingCountry;
    }
}
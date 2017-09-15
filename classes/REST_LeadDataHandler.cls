/*
Handler for requests to the REST_LeadData service

Class:              REST_LeadDataHandler
Date:               06/03/2014
Version:            1
Last Updated:       3/3/2015

Updates:
Modified By : Niket Chandane
        	Modified At : 01-29-2015
        	Summary 	: Case #428005 added Contacted – Not Reached to oppStages

Modified By : Crystal, RedPoint
			Modified On : 2/11/2015
			Summary : added optional Annual Income amount and sales tax rate for accounts as needed for quote api service

Modified By : Crystal, RedPoint
			Modified On : 3/3/2015
			Summary : reworked incoming payloads to run through JSON parser, 
					  added logic across all Lead Api classes to create Spectrum Debug logs to store calls/responses
    *   Stubbed
    *   UAT Completed
////////////////////////////////////////////////////////////////////////////////
*/

public with sharing class REST_LeadDataHandler
{   
    // -------- Constants --------
    // Various feedback messages to the service requests
    private static final String PING_SUCCESS = 'Connection to SunPower LeadData services successful.';
    private static final String INVALID_KEYS = 'No understood parameters passed with the request.';
    private static final String INVALID_VALUES = 'No valid parameters passed with the request.';
    private static final String INVALID_COMPANY_ID = 'This company id is not recognized.';
    private static final String MALFORMED = 'IDs were not in a recognizable format.';
    
    private static final String NO_RECORDS_FOUND = 'No records found.';
    
    // Default values on the created records
    private final String PORTAL_USER_TYPE = 'PowerPartner';
    private final String HOME_OWNER = 'Home Owner';
    private final String LEAD_MANFACTORER = 'Partner';
    private final String OPP_UNIT = 'RLC';
    private final String OPP_DEFAULT_STAGE = 'New Opportunity';
    private final String OPP_DEFAULT_STATUS = 'Active';
    private final String OCR_DEFAULT_ROLE = 'Borrower';
    private final String SIF_DEFAULT_STATUS = 'Active';
    
    // Service names
    private static final String UNCLEAR = 'Unknown';
    private static final String SERVICE_PING = 'Ping';
    private static final String SERVICE_FOR_COMPANY = 'By Company ID';
    private static final String BY_RECORD_IDS = 'For Record IDs';
    private static final String CREATE_UPDATE = 'Create or Update Lead';
    
    // -------- Constructor --------
    public REST_LeadDataHandler(){}
    
    // -------- Variables --------
    // Partners company id and account id, used for record creations
    private String companyID;
    private ID partnerAccountID;

    // Partner user record, for some of the fields on the created/updated records
    private User partnerUser;
    
    // Test values for failure testing create results
    @TestVisible
    private static Boolean failureTesting = false;
    @TestVisible
    private static String failureTestType = '';
    
    
    
    // -------- Properties --------
    // Enums for specifing success and error result types, used in various evaluations throughout the handler
    public Enum SuccessResponseType {SPING, SFORCOMPANY, SFORCOMPANYLIMITED, SIDS}
    public Enum ErrorResponseType {EPARAMETERS, EPING, ECOMPANYID, ECOMPANYEMPTY, EIDSMALFORMED, ECUCOMPANYID}
    
    // Updates must all be successful or they all fail; This holds the failure message
    private String updateFailureError {get; set;}
    
    // Allowed picklist values on certain fields
    private Set<String> oppAMEB;
    private Set<String> oppShading;
    private Set<String> oppStages;
    private Set<String> oppReasonsLost;
    private Set<String> oppReasonsWon;
    
    // -------- Methods --------
    // Confirm the submitted access ID is valid for the service calls, and populate 
    // picklist sets for validation references
    public Boolean confirmAccessID(String accessID)
    {
        Boolean result = false;
        
        if(accessID != null)
        {
            try
            {
                Account validatePartnerAccount = [SELECT ID, PartnerAccessID__c FROM Account WHERE PartnerAccessID__c =: accessID LIMIT 1];
                companyID = accessID;
                partnerAccountID = validatePartnerAccount.ID;
                result = true;
            }
            catch(Exception error)
            {
                result = false;
            }
        }

        return result;
    }
    
    // Populate acceptable picklist values; Not we cannot currently get these values by record type;
    // Shading is not split by record type so its described, others are hard coded
    private void populatePicklists()
    {
        Schema.DescribeFieldResult oppShadingCheck = Opportunity.Shading__c.getDescribe();
        List<Schema.PicklistEntry> shadingList = oppShadingCheck.getPicklistValues();
        oppShading = new Set<String>();
        
        for(Schema.PicklistEntry shadeValue : shadingList)
        {
            if(shadeValue.isActive())
            {
                oppShading.add(shadeValue.getValue());
            }
        }
        
        oppAMEB = new Set<String>{'Less than $100', '$101 to $150', '$151 to $200', '$201 to $250', 
            '$251 to $300', 'Greater than $300', 'Not Sure'};
        
        /*
        	Modified By : Niket Chandane
        	Modified At : 01-29-2015
        	Summary 	: Case #428005 added Contacted – Not Reached
        */
        oppStages = new Set<String>{'New Opportunity', 'Contacted', 'Visit Completed', 'Contract Signed',
        	'Installation Completed', 'Opportunity Lost','Contacted – Not Reached'};
        
        oppReasonsLost = new Set<String>{'Customer Abandon Project / Development', 'Dormant', 'Insufficient budget', 
            'Lost to other SPWR dealer', 'Non-Competitive Financing', 'Not candidate for solar ? Credit',
            'Not candidate for solar ? Low electric bill', 'Not candidate for solar ? Shading', 'Not Price Competitive',
            'Not Strongest Relationship', 'Reroofing'};
        
        oppReasonsWon = new Set<String>{'Best Economics', 'Best Price', 'Best Product', 'Best Services'};
    }
    
    // Ping request
    public REST_LeadDataResults getLeadData(Boolean ping)
    {
        REST_LeadDataResults result;
        
        if(ping)
        {
            result = createSuccessResponse(SuccessResponseType.SPING);
        }
        
        if(result == null)
        {
            result = createErrorResponse(ErrorResponseType.EPING);
        }
        
        try {
            List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.jsonPayload = REST_LeadData.getJSONPayload;
            log.Service = 'Lead (Get Leads)';
            log.Response = JSON.serializePretty(result);
            logs.add(log);
            SpectrumDebugUtility.generateDebugLog(logs);
        } catch(Exception e) {}
        
        return result;
    }
    
    // Records by company request
    public REST_LeadDataResults getLeadData(String companyID)
    {
        Diagnostics.push('getLeadData for company');
        
        REST_LeadDataResults result;
        
        Set<String> recordIDsForCompany = loadAPIRecordIDs(companyID);
        
        if(!recordIDsForCompany.isEmpty())
        {
            result = createSuccessResponse(SuccessResponseType.SFORCOMPANY, recordIDsForCompany);            
        }
        else
        {
            result = createErrorResponse(ErrorResponseType.ECOMPANYEMPTY);
        }
        
        try {
            List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.jsonPayload = REST_LeadData.getJSONPayload;
            log.Service = 'Lead (Get Leads)';
            log.Response = JSON.serializePretty(result);
            logs.add(log);
            SpectrumDebugUtility.generateDebugLog(logs);
        } catch(Exception e) {}
        
        Diagnostics.pop();
        return result;
    }
    
    // Records by company request within hours/days results
    public REST_LeadDataResults getLeadData(String companyID, Integer within, Boolean days)
    {
        Diagnostics.push('getLeadData for company with hours or days');
        
        REST_LeadDataResults result;
        
        Datetime since = datetime.now();
        
        if(days)
        {
            since = since.addDays(-within);
        }
        else
        {
            since = since.addHours(-within);
        }
        
        Map<String, Opportunity> queriedRecords = loadAPIDataWithinTimeframe(since);
        
        if(!queriedRecords.isEmpty())
        {
            result = createSuccessResponse(SuccessResponseType.SFORCOMPANYLIMITED, queriedRecords.values());
        }
        else
        {
            result = createErrorResponse(ErrorResponseType.ECOMPANYEMPTY);
        }
        
        try {
            List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.jsonPayload = REST_LeadData.getJSONPayload;
            log.Service = 'Lead (Get Leads)';
            log.Response = JSON.serializePretty(result);
            logs.add(log);
            SpectrumDebugUtility.generateDebugLog(logs);
        } catch(Exception e) {}
        
        Diagnostics.pop();
        return result;
    }
        
    // Records by specific IDs
    public REST_LeadDataResults getLeadData(String companyID, Set<String> recordIDs)
    {
        Diagnostics.push('getLeadData for record ids');
        
        REST_LeadDataResults result;
        
        Map<String, Opportunity> byIDsResult = loadAPIData(recordIDs);
        Diagnostics.debug('byIDsResult: ' + byIDsResult);
        
        if(!byIDsResult.isEmpty())
        {
            result = createSuccessResponse(SuccessResponseType.SIDS, byIDsResult.values());
        }
        else
        {
            result = createErrorResponse(ErrorResponseType.ECOMPANYEMPTY);
        }
        
        try {
            List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
            log.jsonPayload = REST_LeadData.getJSONPayload;
            log.Service = 'Lead (Get Leads)';
            log.Response = JSON.serializePretty(result);
            logs.add(log);
            SpectrumDebugUtility.generateDebugLog(logs);
        } catch(Exception e) {}
        
        Diagnostics.pop();
        return result;
    }
    
    // Load all fields that may be updated or returned from the service call
    private Map<String, Opportunity> loadAPIData(Set<String> ids)
    {
        system.debug('Ids: ' + ids);
        system.debug('Recordtype?: ' + System.Label.Opportunity_Home_Owner_RD_Id);
        system.debug('partnerAccountID: ' + partnerAccountID);
        Map<String, Opportunity> result = new Map<String, Opportunity>();
        
        try
        {
            List<Opportunity> queryResult = [Select ID, Name, API_ID__c,
                Primary_Contact__r.FirstName, Primary_Contact__r.LastName, Primary_Contact__r.Email, Primary_Contact__r.Phone,
                Account.BillingStreet, Account.BillingCity, Account.BillingPostalCode, Account.BillingState, Account.BillingCountry,
                Account.ShippingStreet, Account.ShippingCity, Account.ShippingPostalCode, Account.ShippingState, Account.ShippingCountry,
                Credit_Application_Status__c, Average_Monthly_Electricity_Bill__c, Shading__c, CloseDate, Amount, StageName,
                Reason_Won_Lost__c, Installation_Completed_Date__c, Referred_By_First_Name__c, Referred_By_Last_Name__c,
                Referral_Program_Status__c, Description, Best_Time_To_Call__c, Alliance_Program_Lead__c, 
                Primary_Campaign_Source_text__c, LeadSource, Lead_Manufacturer__c, Primary_Contact__c, AccountID,
                Account.Income__c, Account.Sales_Tax_Rate__c                           
                FROM Opportunity 
                WHERE Partner_Account_Id__c =: partnerAccountID
                AND RecordTypeID =: System.Label.Opportunity_Home_Owner_RD_Id
                AND API_ID__c IN: ids];
            
            for(Opportunity record: queryResult)
            {
                result.put(record.API_ID__c, record);
            }
        }
        catch(QueryException error)
        {
            Diagnostics.exception(error);
            result = new Map<String, Opportunity>();
        }
        
        return result;
    }
    
    // As above, but within a day or hour range
    private Map<String, Opportunity> loadAPIDataWithinTimeframe(Datetime sinceTimeFrame)
    {
        Map<String, Opportunity> result = new Map<String, Opportunity>();
        
        try
        {
            List<Opportunity> queryResult = [Select ID, Name, API_ID__c, 
                Primary_Contact__r.FirstName, Primary_Contact__r.LastName, Primary_Contact__r.Email, Primary_Contact__r.Phone,
                Account.BillingStreet, Account.BillingCity, Account.BillingPostalCode, Account.BillingState, Account.BillingCountry,
                Account.ShippingStreet, Account.ShippingCity, Account.ShippingPostalCode, Account.ShippingState, Account.ShippingCountry,
                Credit_Application_Status__c, Average_Monthly_Electricity_Bill__c, Shading__c, CloseDate, Amount, StageName,
                Reason_Won_Lost__c, Installation_Completed_Date__c, Referred_By_First_Name__c, Referred_By_Last_Name__c,
                Referral_Program_Status__c, Description, Best_Time_To_Call__c, Alliance_Program_Lead__c, 
                Primary_Campaign_Source_text__c, LeadSource, Lead_Manufacturer__c,Account.Income__c, Account.Sales_Tax_Rate__c
                FROM Opportunity 
                WHERE Partner_Account_Id__c =: partnerAccountID 
                AND RecordTypeID =: System.Label.Opportunity_Home_Owner_RD_Id
                AND LastModifiedDate >: sinceTimeFrame];
            
            for(Opportunity record: queryResult)
            {
                result.put(record.API_ID__c, record);
            }
        }
        catch(QueryException error)
        {
            Diagnostics.exception(error);
            result = new Map<String, Opportunity>();
        }
        
        return result;
    }
    
    // Load partner information used in creating new records
    private User loadPartnerDetails(ID runningUserID)
    {
        User result;
        
        try
        {
            result = [SELECT ID, Contact.AccountId, Contact.Account.Theater__c, Contact.Account.BillingCountry,
                Contact.Account.Oracle_Vendor_Number__c, Contact.Account.Oracle_Vendor_Site_Code__c, Contact.Account.Contact_Language__c,
                Contact.Account.CurrencyIsoCode
                FROM User WHERE ID =: runningUserID];
        }
        catch(QueryException error)
        {
            Diagnostics.exception(error);
        }
        
        return result;
    }
    
    // Load just the record ids for the partner account
    private Set<String> loadAPIRecordIDs(String companyID)
    {
        system.debug('Company ID ' + companyID);
        system.debug('partnerAccountID ' + partnerAccountID);
        Set<String> result = new Set<String>();
        
        try
        {
            List<Opportunity> results = [SELECT ID, API_ID__c 
                FROM Opportunity 
                WHERE Partner_Account_Id__c =: partnerAccountID
                AND RecordTypeID =: System.Label.Opportunity_Home_Owner_RD_Id];
            
            for(Opportunity api : results)
            {
                result.add(api.API_ID__c);
            }
        }
        catch(Exception error)
        {
            Diagnostics.exception(error);
            result = new Set<String>();
        }
        
        return result;
    }
    
////////////////////////////////////////////////////////////////////////////////
    
    // Validation failures map for response to client caller
    private Map<Integer, String> cuErrorMessages = new Map<Integer, String>{
        1 => 'Last Name is required',
        2 => 'First Name may not exceed 40 characters',
        3 => 'Last Name may not exceed 40 characters',
        4 => 'Street address is required',
        5 => 'City is required',
        6 => 'State is required',
        7 => 'Zip code is required',
        8 => 'Country is required',
        9 => 'Phone is required',
        10 => 'Close date is required',
        11 => 'Close date is not in a valid format',
        12 => 'Address is not recognized',
        13 => 'If any part of the billing addresss is included, all parts must be included',
        14 => 'If any part of the shipping addresss is included, all parts must be included'
        };
    
    
    // Valiate fields as far as possible for provided data on record creation
    private Integer validateNewData(REST_LeadModification.LeadRecord record)
    {
        Integer result = 0;
        
        if(record.firstName != null && record.firstName.length() > 40)
        {
            result = 2;
        }
        else if(record.lastName == null)
        {
            result = 1;
        }
        else if(record.lastName.length() > 40)
        {
            result = 3;
        }
        else if(record.billingAddress == null)
        {
            result = 4;
        }
        else if(record.billingCity == null)
        {
            result = 5;
        }
        else if(record.billingState == null)
        {
            result = 6;
        }
        else if(record.billingZipCode == null)
        {
            result = 7;
        }
        else if(record.billingCountry == null)
        {
            result = 8;
        }
        else if(!addressValidationMap.containsKey(String.valueOf(record.billingZipCode + record.billingCity)))
        {
            result = 12;
        }
        else if(record.phone == null)
        {
            result = 9;
        }
        else if(record.closeDate == null)
        {
            result = 10;
        }
        else if(record.closeDate != null)
        {
            try
            {
                Date understoodFormat = date.valueOf(record.closeDate);
            }
            catch(TypeException error)
            {
                result = 11;
            }
        }
        
        if(record.shippingAddress != null || record.shippingCity != null || record.shippingState != null ||
            record.shippingZipCode != null || record.shippingCountry != null)
        {
            if(record.shippingAddress == null || record.shippingCity == null || record.shippingState == null ||
                record.shippingZipCode == null || record.shippingCountry == null)
            {
                result = 14;
            }
            else if(!addressValidationMap.containsKey(String.valueOf(record.shippingZipCode + record.shippingCity)))
            {
                result = 12;
            }
        }
        
        return result;
    }
    
    // As above, but for record updates
    private Integer validateUpdatedData(REST_LeadModification.LeadRecord record)
    {
        Integer result = 0;
        
        if(record.firstName != null && record.firstName.length() > 40)
        {
            result = 2;
        }
        
        if(record.lastName != null && record.lastName.length() > 40)
        {
            result = 1;
        }
        
        if(record.billingAddress != null || record.billingCity != null || record.billingState != null ||
            record.billingZipCode != null || record.billingCountry != null)
        {
            if(record.billingAddress == null || record.billingCity == null || record.billingState == null ||
                record.billingZipCode == null || record.billingCountry == null)
            {
                result = 13;
            }
            else if(!addressValidationMap.containsKey(String.valueOf(record.billingZipCode + record.billingCity)))
            {
                result = 12;
            }
        }
        
        if(record.shippingAddress != null || record.shippingCity != null || record.shippingState != null ||
            record.shippingZipCode != null || record.shippingCountry != null)
        {
            if(record.shippingAddress == null || record.shippingCity == null || record.shippingState == null ||
                record.shippingZipCode == null || record.shippingCountry == null)
            {
                result = 14;
            }
            else if(!addressValidationMap.containsKey(String.valueOf(record.shippingZipCode + record.shippingCity)))
            {
                result = 12;
            }
        }
        
        return result;
    }
////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    // For specifically throwing an error from the services files
    public REST_LeadDataResults throwError(ErrorResponseType errorType)
    {
        REST_LeadDataResults result = createErrorResponse(errorType);
        return result;
    }
    
    // Helpers for managing response creation
    private REST_LeadDataResults createErrorResponse(ErrorResponseType errorType)
    {   
        REST_LeadDataResults result = new ErrorResult(errorType);
        return result;
    }
    
    private REST_LeadDataResults createSuccessResponse(SuccessResponseType successType)
    {
        REST_LeadDataResults result;
        
        if(successType == SuccessResponseType.SPING)
        {
            result = new PingResult();
        }
        
        return result;
    }
    
////////////////////////////////////////////////////////////////////////////////
    
    private REST_LeadDataResults createSuccessResponse(SuccessResponseType successType, Set<String> ids)
    {
        REST_LeadDataResults result;
        
        if(successType == SuccessResponseType.SFORCOMPANY)
        {
            result = new ForCompanyResult(ids);
        }
        
        return result;
    }
    
    
    private REST_LeadDataResults createSuccessResponse(SuccessResponseType successType, List<Opportunity> records)
    {
        REST_LeadDataResults result;
        
        if(successType == SuccessResponseType.SFORCOMPANYLIMITED || 
            successType == SuccessResponseType.SIDS)
        {
            result = new RecordResult(records);
        }
        
        return result;
    }
    
    

    
    // Retrieve the prefix for a type of record for comparing who and what ids
    private String getPrefixFor(Schema.SObjectType objectType)
    {
        return String.valueOf(objectType.getDescribe().getKeyPrefix());
    }
    
    // Insert the records from the created set, returning the save results from each record; Split the records,
    // save the sets, and record the records back for what counts as saved
    // Collect all inserted Opportunity ids for Spectrum Debug Logging objects created when results are returned
    List<ID> insertedIds = new List<ID>();
    private RecordInsertSet handleRecords(String recordType, Map<Integer, sObject> records)
    {
        RecordInsertSet result = new RecordInsertSet();
        
        List<Integer> orderedKeys = new List<Integer>();
        List<sObject> orderedRecords = new List<sObject>();
        Map<Integer, sObject> recordsToInsert = records;
        Integer listTracker = 0;
        
        Database.DMLOptions options = new Database.DMLOptions();
        options.optAllOrNone = false;
        
        for(Integer key : recordsToInsert.keySet())
        {
            orderedKeys.add(key);
            orderedRecords.add(recordsToInsert.get(key));
        }
        
        Database.SaveResult[] transactionResults = Database.insert(orderedRecords, options);
        
        for(Database.SaveResult tResult : transactionResults)
        {
            
             if(tResult.isSuccess())
             {
                if(recordType == 'Account')
                {
                    result.createdAccounts.put(orderedKeys[listTracker], (Account)orderedRecords[listTracker]);
                }
                else if(recordType == 'Contact')
                {
                    result.createdContacts.put(orderedKeys[listTracker], (Contact)orderedRecords[listTracker]);
                }
                else if(recordType == 'Opportunity')
                {
                    result.createdOpps.put(orderedKeys[listTracker], (Opportunity)orderedRecords[listTracker]);
                    insertedIds.add(tResult.getId());
                }
                else if(recordType == 'OCR')
                {
                    result.createdOCRs.put(orderedKeys[listTracker], (OpportunityContactRole)orderedRecords[listTracker]);
                }
                else if(recordType == 'SIF')
                {
                    result.createdSIFs.put(orderedKeys[listTracker], (Site_Information_Form__c)orderedRecords[listTracker]);
                }
                
                result.createdResults.put(orderedKeys[listTracker], tResult);
             }
             else
             {
                result.createdResults.put(orderedKeys[listTracker], tResult);
                result.failedResults.add(orderedKeys[listTracker]);
             }
             
             listTracker++;
            
        }
        
        return result;
    }
    
    
    // -------- Internal Classes --------
    // Children of the REST_LeadDataResult for various responses
    @TestVisible
    class ErrorResult extends REST_LeadDataResults
    {
        public ErrorResult(ErrorResponseType errorType)
        {
            super(false);
            
            if(errorType == ErrorResponseType.EPARAMETERS)
            {
                errorCode = 800;
                errorMessage = REST_LeadDataHandler.INVALID_KEYS;
                requestType = REST_LeadDataHandler.UNCLEAR;
            }
            else if(errorType == ErrorResponseType.EPING)
            {
                errorCode = 801;
                errorMessage = REST_LeadDataHandler.INVALID_VALUES;
                requestType = REST_LeadDataHandler.SERVICE_PING;
            }
            else if(errorType == ErrorResponseType.ECOMPANYID)
            {
                errorCode = 802;
                errorMessage = REST_LeadDataHandler.INVALID_COMPANY_ID;
                requestType = REST_LeadDataHandler.SERVICE_FOR_COMPANY;
            }
            else if(errorType == ErrorResponseType.ECOMPANYEMPTY)
            {
                errorCode = 803;
                errorMessage = REST_LeadDataHandler.NO_RECORDS_FOUND;
                requestType = REST_LeadDataHandler.SERVICE_FOR_COMPANY;
            }
            else if(errorType == ErrorResponseType.EIDSMALFORMED)
            {
                errorCode = 804;
                errorMessage = REST_LeadDataHandler.MALFORMED;
                requestType = REST_LeadDataHandler.BY_RECORD_IDS;
            }
            else if(errorType == ErrorResponseType.ECUCOMPANYID)
            {
                errorCode = 802;
                errorMessage = REST_LeadDataHandler.INVALID_COMPANY_ID;
                requestType = REST_LeadDataHandler.CREATE_UPDATE;
            }
        }
        
        public Integer errorCode {get; set;}
        public String errorMessage {get; set;}
        public String requestType {get; set;}
    }
    
    @TestVisible
    class PingResult extends REST_LeadDataResults
    {
        public PingResult()
        {
            super(true);
            successMessage = REST_LeadDataHandler.PING_SUCCESS;
        }
        
        public String successMessage {get; set;}
    }
    
    @TestVisible
    class ForCompanyResult extends REST_LeadDataResults
    {
        public ForCompanyResult(Set<String> ids)
        {
            super(true);
            buildLeadIDList(ids);
            Diagnostics.debug('leadIDsByCompany: ' + leadIDsByCompany);
        }
        
        public List<LeadID> leadIDsByCompany {get; set;}  
        
        private void buildLeadIDList(Set<String> ids)
        {
            leadIDsByCompany = new List<LeadID>();
            
            for(String value : ids)
            {
                LeadID record = new LeadID();
                record.recordID = value;
                
                leadIDsByCompany.add(record);
            }
        }
    }
    
    class LeadID
    {
        public String recordID {get; set;}
    }
    
    @TestVisible
    class RecordResult extends REST_LeadDataResults
    {
        public RecordResult(List<Opportunity> queriedData)
        {
            super(true);
            buildResults(queriedData);
        }
        
        public List<LeadResult> leadRecords {get; set;}
        
        private void buildResults(List<Opportunity> queriedData)
        {
            leadRecords = new List<LeadResult>();
            
            for(Opportunity result : queriedData)
            {
                LeadResult record = new LeadResult();
                record.recordID = result.API_ID__c;
                
                record.billingStreet = result.Account.BillingStreet;
                record.billingCity = result.Account.BillingCity;
                record.billingState = result.Account.BillingState;
                record.billingZipCode = result.Account.BillingPostalCode;
                record.billingCountry = result.Account.BillingCountry;
                record.shippingStreet = result.Account.shippingStreet;
                record.shippingCity = result.Account.shippingCity;
                record.shippingState = result.Account.shippingState;
                record.shippingZipCode = result.Account.shippingPostalCode;
                record.shippingCountry = result.Account.shippingCountry;
                
                
                record.firstName = result.Primary_Contact__r.FirstName;
                record.lastName = result.Primary_Contact__r.LastName;
                record.email = result.Primary_Contact__r.Email;
                record.phone = result.Primary_Contact__r.Phone;
                
                record.opportunityName = result.Name;
                record.creditCheckStatus = result.Credit_Application_Status__c;
                record.averageMonthlyElectricBill = result.Average_Monthly_Electricity_Bill__c;
                record.shading = result.Shading__c;
                record.closeDate = result.CloseDate;
                record.amount = (result.Amount == null) ? null : result.Amount;
                record.stageName = result.StageName;
                record.reasonWonLost = result.Reason_Won_Lost__c;
                record.installationCompletedDate = result.Installation_Completed_Date__c;
                record.referredByFirstName = result.Referred_By_First_Name__c;
                record.referredByLastName = result.Referred_By_Last_Name__c;
                record.referralProgramStatus = result.Referral_Program_Status__c;
                record.description = result.Description;
                record.bestTimeToCall = result.Best_Time_To_Call__c;
                record.allianceProgramLead = result.Alliance_Program_Lead__c;
                record.primaryCampaignSource = result.Primary_Campaign_Source_text__c;
                record.leadSource = result.LeadSource;
                record.leadManufacturer = result.Lead_Manufacturer__c;
                //added sales tax rate and annual income info for quote REST services
                record.salesTaxRate = (result.Account.Sales_Tax_Rate__c == null) ? 0.0 : result.Account.Sales_Tax_Rate__c;
                record.annualIncome = (result.Account.Income__c == null) ? 100000 : result.Account.Income__c;
                leadRecords.add(record);
            }
        }
    }
    
    class LeadResult
    {
        public String recordID {get; set;}  
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String email {get; set;}
        public String phone {get; set;}
        public String opportunityName {get; set;}
        public Date closeDate {get; set;}
        public String creditCheckStatus {get; set;}
        public String averageMonthlyElectricBill {get; set;}
        public String shading {get; set;}
        public Decimal amount {get; set;}
        public String stageName {get; set;}
        public String reasonWonLost {get; set;}
        public Date installationCompletedDate {get; set;}
        public String referredByFirstName {get; set;}
        public String referredByLastName {get; set;}
        public String referralProgramStatus {get; set;}
        public String description {get; set;}
        public String bestTimeToCall {get; set;}
        public Boolean allianceProgramLead {get; set;}
        public String primaryCampaignSource {get; set;}
        public String leadSource {get; set;}
        public String leadManufacturer {get; set;}
        public String billingStreet {get; set;}
        public String billingCity {get; set;}
        public String billingState {get; set;}
        public String billingZipCode {get; set;}
        public String billingCountry {get; set;}
        public String shippingStreet {get; set;}
        public String shippingCity {get; set;}
        public String shippingState {get; set;}
        public String shippingZipCode {get; set;}
        public String shippingCountry {get; set;}
        //added optional Annual Income amount and sales tax rate for accounts as needed for quote api service
        //2/11/2015 - Crystal, RedPoint
        public Decimal annualIncome {get;set;}
        public Decimal salesTaxRate {get;set;}
    }
    
    // These children are for the processing of creating and inserting brand new records
    class RecordCreationSet
    {
        public RecordCreationSet()
        {
            newAccounts = new Map<Integer, Account>();
            newContacts = new Map<Integer, Contact>();
            newOpps = new Map<Integer, Opportunity>();
            newOCRs = new Map<Integer, OpportunityContactRole>();
            newSiteInfo = new Map<Integer, Site_Information_Form__c>();
            newRecordToGroupedID = new Map<Integer, String>();
        }
        
        public Map<Integer, Account> newAccounts {get; set;}
        public Map<Integer, Contact> newContacts {get; set;}
        public Map<Integer, Opportunity> newOpps {get; set;}
        public Map<Integer, OpportunityContactRole> newOCRs {get; set;}
        public Map<Integer, Site_Information_Form__c> newSiteInfo {get; set;}
        public Map<Integer, String> newRecordToGroupedID {get; set;}
    } 
    
    class RecordInsertSet
    {
        public RecordInsertSet()
        {
            createdAccounts = new Map<Integer, Account>();
            createdContacts = new Map<Integer, Contact>();
            createdOpps = new Map<Integer, Opportunity>();
            createdOCRs = new Map<Integer, OpportunityContactRole>();
            createdSIFs = new Map<Integer, Site_Information_Form__c>();
            failedResults = new Set<Integer>();
            createdResults = new Map<Integer, Database.SaveResult>();
        }
        
        Map<Integer, Database.SaveResult> createdResults;
        Set<Integer> failedResults {get; set;}
        Map<Integer, Account> createdAccounts {get; set;}
        Map<Integer, Contact> createdContacts {get; set;}
        Map<Integer, Opportunity> createdOpps {get; set;}
        Map<Integer, OpportunityContactRole> createdOCRs {get; set;}
        Map<Integer, Site_Information_Form__c> createdSIFs {get; set;}
    }
    
    @TestVisible
    public class CreateUpdateResult extends REST_LeadDataResults
    {
        public CreateUpdateResult(List<FailedResult> failed, List<NewResults> created, List<UpdateResults> updated)
        {
            super(true);
            failedRecords = failed;
            createdRecords = created;
            updatedRecords = updated;
        }
        
        public List<FailedResult> failedRecords {get; set;}
        public List<NewResults> createdRecords {get; set;}
        public List<UpdateResults> updatedRecords {get; set;}
    }
    
    @TestVisible
    public abstract class CreateUpdateResults
    {
        public String recordID {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
    }
    
    @TestVisible
    public class FailedResult extends CreateUpdateResults
    {
        public String errorMessage {get; set;}
    }
    
    @TestVisible
    public class NewResults extends CreateUpdateResults
    {
        
    }
    
    @TestVisible
    public class UpdateResults extends CreateUpdateResults
    {
        
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Create a failed result
    private FailedResult createFailedResult(String id, String firstName, String lastName, String failureMessage)
    {
        FailedResult result = new FailedResult();
        result.recordID = id;
        result.firstName = firstName;
        result.lastName = lastName;
        result.errorMessage = failureMessage;
        
        return result;
        
    }
    
    // Load and prep address validation records by zip code and city combination
    private Map<String, Vertex_Address_Validation__c> addressValidationMap {get; set;}
    
    private void loadAddressValidations(Set<String> zipCodes)
    {
        try
        {
            addressValidationMap = new Map<String, Vertex_Address_Validation__c>();
            
            List<Vertex_Address_Validation__c> queryResults = [SELECT ID, Geo_Postal_Code__c, Geo_City__c, Geo_County__c 
                FROM Vertex_Address_Validation__c WHERE Geo_Postal_Code__c =: zipCodes];
            
            for(Vertex_Address_Validation__c vaResult : queryResults)
            {
                String zipCityCombo = vaResult.Geo_Postal_Code__c + vaResult.Geo_City__c;
                addressValidationMap.put(zipCityCombo, vaResult);
            } 
        }
        catch(Exception error)
        {
            Diagnostics.exception(error);
            addressValidationMap = new Map<String, Vertex_Address_Validation__c>();
        }
    }
    
    // Handle all process of the lead data records, and return the completed result for all success and failures
    public REST_LeadDataResults upsertLeadRecordData(String companyID, List<REST_LeadModification.LeadRecord> records)
    {
        Diagnostics.push('upsertLeadRecordData');
        
        REST_LeadDataResults result;
        List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
        Map<Integer, REST_LeadModification.LeadRecord> createRecords = new Map<Integer, REST_LeadModification.LeadRecord>();
        Map<String, REST_LeadModification.LeadRecord> updateRecords = new Map<String, REST_LeadModification.LeadRecord>();
        List<FailedResult> failedResults = new List<FailedResult>();
        List<NewResults> newRecords = new List<NewResults>();
        Set<String> zipCodeValidationSet = new Set<String>();
        Map<ID, Account> loadedSuccessDataForResponses = new Map<ID, Account>();
        Integer newRecordTrack = 0;
        
        // Load / create picklists for the opps to compare received values
        populatePicklists();
        
        // Collect zip codes for address validation and county assignment during creation
        for(REST_LeadModification.LeadRecord record: records)
        {
            if(record.billingZipCode != null)
            {
                zipCodeValidationSet.add(record.billingZipCode);
            }
            
            if(record.shippingZipCode != null)
            {
                zipCodeValidationSet.add(record.shippingZipCode);
            }
        }
        
        loadAddressValidations(zipCodeValidationSet);
        
        // Split and validate all data
        for(REST_LeadModification.LeadRecord record: records)
        {
            if(record.recordID == null)
            {
                Integer validateResult = validateNewData(record);
                
                if(validateResult == 0)
                {
                    createRecords.put(newRecordTrack, record);
                    newRecordTrack++;
                }
                else
                {
                    failedResults.add(createFailedResult(null, record.firstName, record.lastName, 
                        cuErrorMessages.get(validateResult)));
                }
            }
            else
            {
                Integer validateResult = validateUpdatedData(record);
                
                if(validateResult == 0)
                {
                    updateRecords.put(record.recordID, record);
                    newRecordTrack++;
                }
                else
                {
                    failedResults.add(createFailedResult(null, record.firstName, record.lastName, 
                        cuErrorMessages.get(validateResult)));
                }
            }
        }
        
        // Load partner details if we have records of either type
        if(!createRecords.isEmpty() || !updateRecords.isEmpty())
        {
            if(UserInfo.getUserType() == PORTAL_USER_TYPE)
            {
                partnerUser = loadPartnerDetails(Userinfo.getUserId());
            }
        }
        
        // Handle record creation and roll back for all new records
        if(!createRecords.isEmpty())
        {
            // Created record sets
            RecordCreationSet preppedRecords = createdRecordSet(createRecords);
            RecordInsertSet accountResults;
            RecordInsertSet contactResults;
            RecordInsertSet oppResults;
            RecordInsertSet ocrResults;
            RecordInsertSet siteResults;
           
            
            // Success and failure references, records to delete when failures occur;
            // Order of operation is Account > Contact > Opp > OCR > Site
            Map<Integer, ID> masterSuccessByAccountID = new Map<Integer, ID>();
            Map<Integer, List<DataBase.Error>> masterFailureByRecordTrack = new Map<Integer, List<DataBase.Error>>();
            List<Account> accountsToDeleteOnFailures = new List<Account>();
                        
            // Map of API records to ID to return to calling client
            Map<ID, String> associatedRecordsByAccount = new Map<ID, String>();
            
            // Confirm records created successfully, and start processing
            if(!preppedRecords.newAccounts.isEmpty())
            {		
                // All of the following opperate in the same fashion; On success, assign needed values to the
                // next set of records to create like ids; On failure, remove associated future records from
                // being created and record any account deletion that needs to occur (which will cascade into
                // deleteing contact / opp / ocr - site is the last thing made only when everything else so 
                // no need to worry about deletion yet);
                // All created accounts are assumed successful until another operation fails and they are removed,
                // so they are recorded in the first loop and removed from subsiquent loops on failures
                accountResults = handleRecords('Account', (Map<Integer, sObject>)preppedRecords.newAccounts);
                
                for(Integer accountResult : accountResults.createdResults.keySet())
                {	 
                    if(!accountResults.createdResults.get(accountResult).isSuccess())
                    {
                        masterFailureByRecordTrack.put(accountResult, accountResults.createdResults.get(accountResult).getErrors());
                        preppedRecords.newContacts.remove(accountResult);
                        preppedRecords.newOpps.remove(accountResult);
                        preppedRecords.newOCRs.remove(accountResult);
                        preppedRecords.newSiteInfo.remove(accountResult);
                    }
                    else
                    {
                        masterSuccessByAccountID.put(accountResult, accountResults.createdResults.get(accountResult).getID());
                        preppedRecords.newContacts.get(accountResult).AccountID = 
                            accountResults.createdAccounts.get(accountResult).ID;
                        preppedRecords.newSiteInfo.get(accountResult).Account__c = 
                            accountResults.createdAccounts.get(accountResult).ID;
                    }
                }
                
                contactResults = handleRecords('Contact', (Map<Integer, sObject>)preppedRecords.newContacts);
                for(Integer contactResult : contactResults.createdResults.keySet())
                {
                    if(!contactResults.createdResults.get(contactResult).isSuccess())
                    {
                        masterFailureByRecordTrack.put(contactResult, contactResults.createdResults.get(contactResult).getErrors());
                        accountsToDeleteOnFailures.add(accountResults.createdAccounts.get(contactResult));
                        preppedRecords.newOpps.remove(contactResult);
                        preppedRecords.newOCRs.remove(contactResult);
                        preppedRecords.newSiteInfo.remove(contactResult);
                        
                        masterSuccessByAccountID.remove(contactResult);
                    }
                    else
                    {
                        preppedRecords.newOpps.get(contactResult).AccountID = 
                            accountResults.createdAccounts.get(contactResult).ID;
                        preppedRecords.newOpps.get(contactResult).Primary_Contact__c = 
                            contactResults.createdContacts.get(contactResult).ID;
                    }
                }
                
                oppResults = handleRecords('Opportunity', (Map<Integer, sObject>)preppedRecords.newOpps);
                for(Integer oppResult : oppResults.createdResults.keySet())
                {
                    if(!oppResults.createdResults.get(oppResult).isSuccess())
                    {
                        masterFailureByRecordTrack.put(oppResult, oppResults.createdResults.get(oppResult).getErrors());
                        accountsToDeleteOnFailures.add(accountResults.createdAccounts.get(oppResult));
                        preppedRecords.newOCRs.remove(oppResult);
                        preppedRecords.newSiteInfo.remove(oppResult);
                        
                        masterSuccessByAccountID.remove(oppResult);
                    }
                    else
                    {
                        preppedRecords.newOCRs.get(oppResult).OpportunityId = 
                            oppResults.createdOpps.get(oppResult).ID;
                        preppedRecords.newOCRs.get(oppResult).ContactId = 
                            contactResults.createdContacts.get(oppResult).ID;
                        
                        // For failure testing OCRs, which unfortunatly cannot be manipulated with OCRs until here,
                        // and the creation sets primary to false for the scenerio
                        if(Test.isRunningTest() && failureTesting && (failureTestType == 'OCR' || failureTestType == 'All'))
                        {
                            if(preppedRecords.newOCRs.get(oppResult).IsPrimary == false)
                            {
                                preppedRecords.newOCRs.get(oppResult).OpportunityId = null;
                            }
                        }
                    }
                }
                
                ocrResults = handleRecords('OCR', (Map<Integer, sObject>)preppedRecords.newOCRs);
                for(Integer ocrResult : ocrResults.createdResults.keySet())
                {
                    if(!ocrResults.createdResults.get(ocrResult).isSuccess())
                    {
                        masterFailureByRecordTrack.put(ocrResult, ocrResults.createdResults.get(ocrResult).getErrors());
                        accountsToDeleteOnFailures.add(accountResults.createdAccounts.get(ocrResult));
                        preppedRecords.newSiteInfo.remove(ocrResult);
                        
                        masterSuccessByAccountID.remove(ocrResult);
                    }
                }
                
                siteResults = handleRecords('SIF', (Map<Integer, sObject>)preppedRecords.newSiteInfo);
                for(Integer siteResult : siteResults.createdResults.keySet())
                {
                    if(!siteResults.createdResults.get(siteResult).isSuccess())
                    {
                        masterFailureByRecordTrack.put(siteResult, siteResults.createdResults.get(siteResult).getErrors());
                        accountsToDeleteOnFailures.add(accountResults.createdAccounts.get(siteResult));
                        
                        masterSuccessByAccountID.remove(siteResult);
                    }
                }
                
                if(!accountsToDeleteOnFailures.isEmpty())
                {
                    try
                    {
                        delete accountsToDeleteOnFailures;
                    }
                    catch(DMLException aError)
                    {
                        Diagnostics.exception(aError);
                    }
                }
                
                // Reload the data needed for the response to the end client
                if(!masterSuccessByAccountID.isEmpty())
                {
                    try
                    {
                        loadedSuccessDataForResponses = new Map<ID, Account>([SELECT ID, 
                            (SELECT ID, API_ID__c FROM Opportunities)
                            FROM Account WHERE ID =: masterSuccessByAccountID.values()]);
                    }
                    catch(Exception error)
                    {
                        
                    }
                }
            }
            
                    
            // Finally, create response records on new record creations
            if(!loadedSuccessDataForResponses.isEmpty())
            {    
                for(Integer key : masterSuccessByAccountID.keySet())
                {
                    NewResults createdRecord = new NewResults();
                    createdRecord.recordID = loadedSuccessDataForResponses.get(
                        masterSuccessByAccountID.get(key)).Opportunities[0].API_ID__c;
                    createdRecord.firstName = createRecords.get(key).firstName;
                    createdRecord.lastName = createRecords.get(key).lastName;
                    
                    newRecords.add(createdRecord);
                }
                
                for(Integer key : masterFailureByRecordTrack.keySet())
                {
                    FailedResult fvResult = new FailedResult();
                    
                    fvResult.recordID = null;
                    fvResult.firstName = (createRecords.get(key).firstName == null) ? null : createRecords.get(key).firstName;
                    fvResult.lastName = (createRecords.get(key).lastName == null) ? null : createRecords.get(key).lastName;
                    fvResult.errorMessage = '';
                    
                    for(DataBase.Error error : masterFailureByRecordTrack.get(key))
                    {
                        fvResult.errorMessage += error.getMessage();
                    }
                    
                    failedResults.add(fvResult);
                }   
            }
        }
        
        // Now that new records are handled, handle updates to existing records
        List<UpdateResults> updatedRecordResults = new List<UpdateResults>();
        if(!updateRecords.isEmpty())
        {
            Diagnostics.debug('updateRecords: ' + updateRecords);
            updatedRecordResults = updateExistingRecords(updateRecords);
            Diagnostics.debug('updatedRecordResults: ' + updatedRecordResults);
            
            
            if(updatedRecordResults == null)
            {
                FailedResult fvResult = new FailedResult();
                fvResult.errorMessage = 'All records with an ID failed to update. Error: ' + updateFailureError;
                
                failedResults.add(fvResult);
                updatedRecordResults = new List<UpdateResults>();
            }
        }
        
        result = new CreateUpdateResult(failedResults, newRecords, updatedRecordResults);
        
        Diagnostics.pop();
        List<SpectrumDebugUtility.debugLog> logsToInsert = new List<SpectrumDebugUtility.debugLog>();
        //create debug log for inserted records
        try {
            if(!insertedIds.isEmpty()) {
                for(Id i : insertedIds) {
                    SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                    log.jsonPayload = REST_LeadModification.jsonPayload;
                    log.Service = 'Lead (Create/Modification)';
                    log.Response = JSON.serializePretty(result);
                    log.OpportunityId = i;
                    logsToInsert.add(log);
                }
            } else {
                SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                log.jsonPayload = REST_LeadModification.jsonPayload;
                log.Service = 'Lead (Create/Modification)';
                log.Response = JSON.serializePretty(result);
                logsToInsert.add(log);
            }
          SpectrumDebugUtility.generateDebugLog(logsToInsert);
        } catch(Exception debugEx) {}
        
        return result;
    }
    
    // Load and update existing records via service; load associated records, created the 
    // record types, update applicable fields, and record results
    private List<UpdateResults> updateExistingRecords(Map<String, REST_LeadModification.LeadRecord> updates)
    {
        List<UpdateResults> result = new List<UpdateResults>();
        
        Boolean invalidID = false;
        
        Map<String, Opportunity> apiRecords = loadAPIData(updates.keySet());
        Diagnostics.debug('apiRecords: ' + apiRecords);
        
        Map<String, Integer> apiIDToPreppedRecord = new Map<String, Integer>();
        
        Map<Integer, REST_LeadModification.LeadRecord> prepareRecordParsing = new Map<Integer, REST_LeadModification.LeadRecord>();
        
        Map<String, Account> accountsToUpdate = new Map<String, Account>();
        Map<String, Contact> contactsToUpdate = new Map<String, Contact>();
        Map<String, Opportunity> opportunitiesToUpdate = new Map<String, Opportunity>();
        
        // Confirm we have all the records, and if not, record a failure and exit
        for(String key : updates.keySet())
        {
            if(!apiRecords.containsKey(key))
            {
                if(updateFailureError == null)
                {
                    updateFailureError = '';
                }
                
                updateFailureError += 'No record found for ID ' + key + '. ';
                invalidID = true;
                result = null;
            }
        }
        
        if(!apiRecords.isEmpty() && !invalidID)
        {
            Integer recordTrack = 0;
            
            for(String key : updates.keySet())
            {
                apiIDToPreppedRecord.put(key, recordTrack);
                prepareRecordParsing.put(recordTrack, updates.get(key));
                recordTrack++;
            }
            
            RecordCreationSet preppedRecords = createdUpdateRecordSet(prepareRecordParsing);
            Diagnostics.debug('preppedRecords: ' + preppedRecords);
            
            // Match ids to existing prepped records
            for(String key : apiRecords.keySet())
            {
                if(preppedRecords.newAccounts.containsKey(apiIDToPreppedRecord.get(key)))
                {
                    Diagnostics.debug('Account to update');
                    preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).ID = apiRecords.get(key).AccountID;
                    accountsToUpdate.put(key, preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)));
                }
                
                if(preppedRecords.newContacts.containsKey(apiIDToPreppedRecord.get(key)))
                {
                    Diagnostics.debug('Contact to update');
                    preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).ID = apiRecords.get(key).Primary_Contact__c;
                    contactsToUpdate.put(key, preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)));
                }
                
                Diagnostics.debug('Opp to update');
                
                try
                {
                    Diagnostics.debug('preppedRecords.newOpps: ' + preppedRecords.newOpps);
                    Diagnostics.debug('apiIDToPreppedRecord.newOpps: ' + apiIDToPreppedRecord);
                    
                    Opportunity updateOpp = preppedRecords.newOpps.get(apiIDToPreppedRecord.get(key));
                    Diagnostics.debug('updateOpp: ' + updateOpp);
                    
                    updateOpp.ID = apiRecords.get(key).ID;
                    Diagnostics.debug('updateOpp: ' + updateOpp);
                    
                    //preppedRecords.newOpps.get(apiIDToPreppedRecord.get(key)).ID = apiRecords.get(key).ID;
                    opportunitiesToUpdate.put(key, updateOpp);
                }
                catch(Exception error)
                {
                    Diagnostics.exception(error);
                }
                
                
                /*
                Account updateAccount = new Account();
                updateAccount.Name = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).Name;
                updateAccount.ShippingCountry = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).ShippingCountry;
                updateAccount.BillingCountry = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).BillingCountry;
                updateAccount.ShippingCity = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).ShippingCity;
                updateAccount.BillingCity = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).BillingCity;
                updateAccount.ShippingStreet = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).ShippingStreet;
                updateAccount.BillingStreet = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).BillingStreet;
                updateAccount.ShippingState = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).ShippingState;
                updateAccount.BillingState = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).BillingState;
                updateAccount.ShippingPostalCode = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).ShippingPostalCode;
                updateAccount.BillingPostalCode = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).BillingPostalCode;
                updateAccount.ID = apiRecords.get(key).Account__c;
                
                Contact updateContact = new Contact();
                updateContact.FirstName = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).FirstName;
                updateContact.LastName = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).LastName;
                updateContact.Phone = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).Phone;
                updateContact.Email = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).Email;
                updateContact.MailingState = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).MailingState;
                updateContact.MailingCountry = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).MailingCountry;
                updateContact.MailingCity = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).MailingCity;
                updateContact.MailingStreet = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).MailingStreet;
                updateContact.MailingPostalCode = preppedRecords.newContacts.get(apiIDToPreppedRecord.get(key)).MailingPostalCode;
                updateContact.ID = apiRecords.get(key).Contact__c;
                
                Opportunity updateOpp = new Opportunity();
                updateOpp.Country__c = preppedRecords.newOpps.get(apiIDToPreppedRecord.get(key)).Country__c;
                updateOpp.Name = preppedRecords.newAccounts.get(apiIDToPreppedRecord.get(key)).Name;
                
                if(preppedRecords.newOpps.get(apiIDToPreppedRecord.get(key)).CloseDate != null)
                {
                    updateOpp.CloseDate = preppedRecords.newOpps.get(apiIDToPreppedRecord.get(key)).CloseDate;
                }
                
                updateOpp.ID = apiRecords.get(key).Opportunity__c;
                
                accountsToUpdate.put(key, updateAccount);
                contactsToUpdate.put(key, updateContact);
                opportunitiesToUpdate.put(key, updateOpp);
                */
            }
            
            Diagnostics.debug('accountsToUpdate: ' + accountsToUpdate);
            Diagnostics.debug('contactsToUpdate: ' + contactsToUpdate);
            Diagnostics.debug('opportunitiesToUpdate: ' + opportunitiesToUpdate);
            
            // Opp updates must be successful to count, then account and contact updates are made
            Savepoint sp = Database.setSavepoint();
            
            if(!opportunitiesToUpdate.isEmpty())
            {
                try
                {
                    Boolean oppsUpdateSuccessful = false;
                    
                    try
                    {
                        update opportunitiesToUpdate.values();
                        oppsUpdateSuccessful = true;
                    }
                    catch(Exception oppFailure)
                    {
                        updateFailureError = oppFailure.getMessage();
                        result = null;
                        Database.rollback(sp);
                    }
                    
                    if(oppsUpdateSuccessful)
                    {
                        update accountsToUpdate.values();
                        update contactsToUpdate.values();
                        
                        if(Test.isRunningTest() && failureTesting && failureTestType == 'Update')
                        {
                            Integer x = 1 / 0;
                        }
                        
                        for(String key : updates.keySet())
                        {
                            UpdateResults updateResult = new UpdateResults();
                            updateResult.recordID = key;
                            updateResult.firstName = updates.get(key).firstName;
                            updateResult.lastName = updates.get(key).lastName;
                            
                            result.add(updateResult);
                        }
                    }
                    
                }
                catch(Exception failure)
                {
                    updateFailureError = failure.getMessage();
                    result = null;
                    Database.rollback(sp);
                }
            }
        }

        return result;
    }
    
////////////////////////////////////////////////////////////////////////// GOOD
    
    
    
    
    
    // Create all records needed for insert and map them to a return object wrapper
    private RecordCreationSet createdRecordSet(Map<Integer, REST_LeadModification.LeadRecord> newRecords)
    {
        RecordCreationSet result = new RecordCreationSet();
                
        for(Integer key : newRecords.keySet())
        {
            Account newAccount = new Account();
            Contact newContact = new Contact();
            Opportunity newOpportunity = new Opportunity();
            OpportunityContactRole newOCR = new OpportunityContactRole();
            Site_Information_Form__c newSIF = new Site_Information_Form__c();
            
            newAccount.RecordTypeID = System.Label.ART_RC;
            newAccount.IsExcludedFromRealign = true;
            newAccount.Type = HOME_OWNER;
            newAccount.BillingCountry = newRecords.get(key).billingCountry;
            newAccount.BillingCity = newRecords.get(key).billingCity;
            newAccount.BillingStreet = newRecords.get(key).billingAddress;
            newAccount.BillingState = newRecords.get(key).billingState;
            newAccount.BillingPostalCode = newRecords.get(key).billingZipCode;
           
            //added default vals for quote api 2/11/15 - Crystal, RedPoint
            newAccount.Sales_Tax_Rate__c = (newRecords.get(key).salesTaxRate == null) ? 0.0 : newRecords.get(key).salesTaxRate;
            newAccount.Income__c = (newRecords.get(key).annualIncome == null) ? 100000 : newRecords.get(key).annualIncome;
            
            String oracleCountyKey = newRecords.get(key).billingZipCode + newRecords.get(key).billingCity;
            
            if(addressValidationMap.containsKey(oracleCountyKey))
            {
                newAccount.Oracle_County__c = addressValidationMap.get(oracleCountyKey).Geo_County__c;
            }
            
            newAccount.ShippingCountry = (newRecords.get(key).shippingCountry == null) ? newAccount.BillingCountry : 
                newRecords.get(key).shippingCountry;
            newAccount.ShippingCity = (newRecords.get(key).shippingCity == null) ? newAccount.BillingCity : 
                newRecords.get(key).shippingCity;
            newAccount.ShippingStreet = (newRecords.get(key).shippingAddress == null) ? newAccount.BillingStreet : 
                newRecords.get(key).shippingAddress;
            newAccount.ShippingState = (newRecords.get(key).shippingState == null) ? newAccount.BillingState : 
                newRecords.get(key).shippingState;
            newAccount.ShippingPostalCode = (newRecords.get(key).shippingZipCode == null) ? newAccount.BillingPostalCode : 
                newRecords.get(key).shippingZipCode;
            
            String oracleCountyShippingKey = newAccount.ShippingPostalCode + newAccount.ShippingCity;
            
            if(addressValidationMap.containsKey(oracleCountyShippingKey))
            {
                newAccount.Oracle_Shipping_County__c = addressValidationMap.get(oracleCountyShippingKey).Geo_County__c;
            }
            else
            {
                newAccount.Oracle_Shipping_County__c = newAccount.Oracle_County__c;
            }
            
            String accountName = (newRecords.get(key).firstName == null) ? '' : newRecords.get(key).firstName + ' ';
            accountName += newRecords.get(key).lastName;
            newAccount.Name = accountName;
            
            if(Test.isRunningTest() && failureTesting && (failureTestType == 'Account' || failureTestType == 'All') && 
                newRecords.get(key).lastName == 'AccountFailure')
            {
                newAccount.Name = null;
            }
            
            if(partnerUser != null)
            {
                newAccount.Theater__c = newOpportunity.Theater__c = partnerUser.Contact.Account.Theater__c;
                newAccount.Oracle_Vendor_Number__c = partnerUser.Contact.Account.Oracle_Vendor_Number__c;
                newAccount.Oracle_Vendor_Site_Code__c = partnerUser.Contact.Account.Oracle_Vendor_Site_Code__c;
                newAccount.Contact_Language__c = newContact.Contact_Language__c = partnerUser.Contact.Account.Contact_Language__c;
                
                newOpportunity.CurrencyIsoCode = partnerUser.Contact.Account.CurrencyIsoCode;
                newOpportunity.Partner_Account_Id__c = partnerUser.Contact.AccountID;
                newOpportunity.OwnerId = partnerUser.ID;
            }
            
            result.newAccounts.put(key, newAccount);
            
            newContact.Primary__c = true;
            newContact.LastName = newRecords.get(key).lastName;
            newContact.Phone = newRecords.get(key).phone;
            newContact.MailingState = newAccount.BillingState;
            newContact.MailingCountry = newAccount.BillingCountry;
            newContact.MailingCity = newAccount.BillingCity;
            newContact.MailingStreet = newAccount.BillingStreet;
            newContact.MailingPostalCode = newAccount.BillingPostalCode;
            newContact.FirstName = (newRecords.get(key).firstName == null) ? null : newRecords.get(key).firstName;
            newContact.Email = (newRecords.get(key).email == null) ? null : newRecords.get(key).email;
            
            if(Test.isRunningTest() && failureTesting && (failureTestType == 'Contact' || failureTestType == 'All') && 
                newRecords.get(key).lastName == 'ContactFailure')
            {
                newContact.LastName = null;
            }
            
            result.newContacts.put(key, newContact);
            
            newOpportunity.Lead_Manufacturer__c = LEAD_MANFACTORER;
            newOpportunity.Business_Unit__c = OPP_UNIT; 
            newOpportunity.Opportunity_Status__c = OPP_DEFAULT_STATUS;
            newOpportunity.RecordTypeID = System.Label.Opportunity_Home_Owner_RD_Id;
            newOpportunity.Name = (newRecords.get(key).opportunityName == null) ? accountName : 
                newRecords.get(key).opportunityName;
            newOpportunity.Credit_Application_Status_Message__c = (newRecords.get(key).creditCheckStatus == null) ? null : 
                newRecords.get(key).creditCheckStatus;
            newOpportunity.Country__c = newAccount.BillingCountry;
            
            if(newRecords.get(key).closeDate != null)
            {
                newOpportunity.CloseDate = date.valueOf(newRecords.get(key).closeDate);
            }
            
            if(newRecords.get(key).averageMonthlyElectricBill != null && oppAMEB.contains(newRecords.get(key).averageMonthlyElectricBill))
            {
                newOpportunity.Average_Monthly_Electricity_Bill__c = newRecords.get(key).averageMonthlyElectricBill;
            }
            
            if(newRecords.get(key).shading != null && oppShading.contains(newRecords.get(key).shading))
            {
                newOpportunity.Shading__c = newRecords.get(key).shading;
            }
            
            if(newRecords.get(key).stageName != null && oppStages.contains(newRecords.get(key).stageName))
            {
                newOpportunity.StageName = newRecords.get(key).stageName;
            }
            else
            {
                newOpportunity.StageName = OPP_DEFAULT_STAGE;
            }
            
            if(newOpportunity.StageName == 'Opportunity Lost')
            {
                if(newRecords.get(key).reasonWonLost != null && oppReasonsLost.contains(newRecords.get(key).reasonWonLost))
                {
                    newOpportunity.Reason_Won_Lost__c = newRecords.get(key).reasonWonLost;
                }
                else
                {
                    newOpportunity.Reason_Won_Lost__c = 'Dormant';
                }
            }
            else if(newOpportunity.StageName == 'Installation Complete' || 
                newOpportunity.StageName == 'Contract Signed')
            {
                if(newRecords.get(key).reasonWonLost != null && oppReasonsWon.contains(newRecords.get(key).reasonWonLost))
                {
                    newOpportunity.Reason_Won_Lost__c = newRecords.get(key).reasonWonLost;
                }
            }
            
            if(newRecords.get(key).installationCompletedDate != null)
            {
                try
                {
                    newOpportunity.Installation_Completed_Date__c = newRecords.get(key).installationCompletedDate;
                }
                catch(Exception error)
                {
                    // ignored
                }
            }
            
            if(newRecords.get(key).referredByFirstName != null)
            {
                newOpportunity.Referred_By_First_Name__c = newRecords.get(key).referredByFirstName;
            }
            
            if(newRecords.get(key).referredByLastName != null)
            {
                newOpportunity.Referred_By_Last_Name__c = newRecords.get(key).referredByLastName;
            }
            
            if(newRecords.get(key).referralProgramStatus != null)
            {
                newOpportunity.Referral_Program_Status__c = newRecords.get(key).referralProgramStatus;
            }
            
            if(newRecords.get(key).description != null)
            {
                newOpportunity.Description = newRecords.get(key).description;
            }
            
            if(newRecords.get(key).bestTimeToCall != null)
            {
                newOpportunity.Best_Time_To_Call__c = newRecords.get(key).bestTimeToCall;
            }
            
            if(newRecords.get(key).amount != null)
            {
                try
                {
                    newOpportunity.Amount = newRecords.get(key).amount;
                }
                catch(Exception error)
                {
                    // ignore
                }
            }
            
            if(Test.isRunningTest() && failureTesting && (failureTestType == 'Opportunity' || failureTestType == 'All') && 
                newRecords.get(key).lastName == 'OppFailure')
            {
                newOpportunity.StageName = null;
            }
            
            newOpportunity.APICreatedDate__c = date.today();
            newOpportunity.APICreatedVersion__c = '0';
            newOpportunity.APILastModifiedName__c = 'Lead Data';
            
            result.newOpps.put(key, newOpportunity);
            
            newOCR.IsPrimary = true;
            newOCR.Role = OCR_DEFAULT_ROLE;
            
            if(Test.isRunningTest() && failureTesting && (failureTestType == 'OCR' || failureTestType == 'All') && 
                newRecords.get(key).lastName == 'OCRFailure')
            {
                newOCR.IsPrimary = false;
            }
            
            result.newOCRs.put(key, newOCR);
            
            newSIF.Site_Status__c = SIF_DEFAULT_STATUS;
            newSIF.RecordTypeID = System.Label.SIFS_RT;
            
            if(Test.isRunningTest() && failureTesting && (failureTestType == 'Site' || failureTestType == 'All') && 
                newRecords.get(key).lastName == 'SiteFailure')
            {
                newSIF.RecordTypeID = System.Label.Opportunity_Home_Owner_RD_Id;
            }
            
            result.newSiteInfo.put(key, newSIF);
        }
        
        return result;
    }
    
    // As above, but for updates only, so alot more data checking and no default applications like record types,
    // and no sites or ocrs to make
    private RecordCreationSet createdUpdateRecordSet(Map<Integer, REST_LeadModification.LeadRecord> newRecords)
    {
        RecordCreationSet result = new RecordCreationSet();
                
        for(Integer key : newRecords.keySet())
        {
            if(newRecords.get(key).firstName != null || newRecords.get(key).lastName != null ||
                newRecords.get(key).phone != null || newRecords.get(key).email != null || 
                newRecords.get(key).billingAddress != null || newRecords.get(key).billingCity != null ||
                newRecords.get(key).billingState != null || newRecords.get(key).billingZipCode != null ||
                newRecords.get(key).billingCountry != null)
            {
                Contact updateContact = new Contact();
                
                if(newRecords.get(key).firstName != null)
                {
                    updateContact.FirstName = newRecords.get(key).firstName;
                }
                
                if(newRecords.get(key).lastName != null)
                {
                    updateContact.LastName = newRecords.get(key).lastName;
                }
                
                if(newRecords.get(key).phone != null)
                {
                    updateContact.Phone = newRecords.get(key).phone;
                }
                
                if(newRecords.get(key).email != null)
                {
                    updateContact.Email = newRecords.get(key).email;
                }
                
                if(newRecords.get(key).billingAddress != null)
                {
                    updateContact.MailingStreet = newRecords.get(key).billingAddress;
                    updateContact.MailingCity = newRecords.get(key).billingCity;
                    updateContact.MailingState = newRecords.get(key).billingState;
                    updateContact.MailingPostalCode = newRecords.get(key).billingZipCode;
                    updateContact.MailingCountry = newRecords.get(key).billingCountry;
                }
                
                result.newContacts.put(key, updateContact);
            }
            
            if(newRecords.get(key).shippingAddress != null || newRecords.get(key).shippingCity != null ||
                newRecords.get(key).shippingState != null || newRecords.get(key).shippingZipCode != null || 
                newRecords.get(key).shippingCountry != null ||
                newRecords.get(key).billingAddress != null || newRecords.get(key).billingCity != null ||
                newRecords.get(key).billingState != null || newRecords.get(key).billingZipCode != null ||
                newRecords.get(key).billingCountry != null)
            {
                Account updateAccount = new Account();
                updateAccount.IsExcludedFromRealign = true;
                if(newRecords.get(key).billingAddress != null)
                {
                    updateAccount.BillingCountry = newRecords.get(key).billingCountry;
                    updateAccount.BillingCity = newRecords.get(key).billingCity;
                    updateAccount.BillingStreet = newRecords.get(key).billingAddress;
                    updateAccount.BillingState = newRecords.get(key).billingState;
                    updateAccount.BillingPostalCode = newRecords.get(key).billingZipCode;
                    
                    String oracleCountyKey = newRecords.get(key).billingZipCode + newRecords.get(key).billingCity;
                    
                    if(addressValidationMap.containsKey(oracleCountyKey))
                    {
                        updateAccount.Oracle_County__c = addressValidationMap.get(oracleCountyKey).Geo_County__c;
                    }
                }
                
                if(newRecords.get(key).shippingAddress != null)
                {
                    updateAccount.ShippingCountry = newRecords.get(key).shippingCountry;
                    updateAccount.ShippingCity = newRecords.get(key).shippingCity;
                    updateAccount.ShippingStreet = newRecords.get(key).shippingAddress;
                    updateAccount.ShippingState = newRecords.get(key).shippingState;
                    updateAccount.ShippingPostalCode = newRecords.get(key).shippingZipCode;
                    
                    String oracleCountyShippingKey = updateAccount.ShippingPostalCode + updateAccount.ShippingCity;
                    
                    if(addressValidationMap.containsKey(oracleCountyShippingKey))
                    {
                        updateAccount.Oracle_Shipping_County__c = addressValidationMap.get(oracleCountyShippingKey).Geo_County__c;
                    }
                    else if(updateAccount.Oracle_County__c != null)
                    {
                        updateAccount.Oracle_Shipping_County__c = updateAccount.Oracle_County__c;
                    }
                }
                
                result.newAccounts.put(key, updateAccount);
            }
            
            Opportunity updateOpportunity = new Opportunity();
            
            if(newRecords.get(key).closeDate != null)
            {
                updateOpportunity.CloseDate = date.valueOf(newRecords.get(key).closeDate);
            }
            
            if(newRecords.get(key).opportunityName != null)
            {
                updateOpportunity.Name = newRecords.get(key).opportunityName;
            }
            
            if(newRecords.get(key).creditCheckStatus != null)
            {
                updateOpportunity.Credit_Application_Status_Message__c = newRecords.get(key).creditCheckStatus;
            }
            
            if(newRecords.get(key).billingCountry != null)
            {
                updateOpportunity.Country__c = newRecords.get(key).billingCountry;
            }
            
            if(newRecords.get(key).averageMonthlyElectricBill != null && oppAMEB.contains(newRecords.get(key).averageMonthlyElectricBill))
            {
                updateOpportunity.Average_Monthly_Electricity_Bill__c = newRecords.get(key).averageMonthlyElectricBill;
            }
            
            if(newRecords.get(key).shading != null && oppShading.contains(newRecords.get(key).shading))
            {
                updateOpportunity.Shading__c = newRecords.get(key).shading;
            }
            
            if(newRecords.get(key).stageName != null && oppStages.contains(newRecords.get(key).stageName))
            {
                updateOpportunity.StageName = newRecords.get(key).stageName;
                
                if(updateOpportunity.StageName == 'Opportunity Lost')
                {
                    if(newRecords.get(key).reasonWonLost != null && oppReasonsLost.contains(newRecords.get(key).reasonWonLost))
                    {
                        updateOpportunity.Reason_Won_Lost__c = newRecords.get(key).reasonWonLost;
                    }
                }
                else if(updateOpportunity.StageName == 'Installation Complete' || 
                    updateOpportunity.StageName == 'Contract Signed')
                {
                    if(newRecords.get(key).reasonWonLost != null && oppReasonsWon.contains(newRecords.get(key).reasonWonLost))
                    {
                        updateOpportunity.Reason_Won_Lost__c = newRecords.get(key).reasonWonLost;
                    }
                }
            }
            
            if(newRecords.get(key).amount != null)
            {
                try
                {
                    updateOpportunity.Amount = newRecords.get(key).amount;
                }
                catch(Exception error)
                {
                    // ignored
                }
            }
            
            if(newRecords.get(key).installationCompletedDate != null)
            {
                try
                {
                    updateOpportunity.Installation_Completed_Date__c = newRecords.get(key).installationCompletedDate;
                }
                catch(Exception error)
                {
                    // ignored
                }
            }
            
            if(newRecords.get(key).referredByFirstName != null)
            {
                updateOpportunity.Referred_By_First_Name__c = newRecords.get(key).referredByFirstName;
            }
            
            if(newRecords.get(key).referredByLastName != null)
            {
                updateOpportunity.Referred_By_Last_Name__c = newRecords.get(key).referredByLastName;
            }
            
            if(newRecords.get(key).referralProgramStatus != null)
            {
                updateOpportunity.Referral_Program_Status__c = newRecords.get(key).referralProgramStatus;
            }
            
            if(newRecords.get(key).description != null)
            {
                updateOpportunity.Description = newRecords.get(key).description;
            }
            
            if(newRecords.get(key).bestTimeToCall != null)
            {
                updateOpportunity.Best_Time_To_Call__c = newRecords.get(key).bestTimeToCall;
            }
            
            updateOpportunity.APILastUpdatedDate__c = date.today();
            updateOpportunity.APILastUpdatedVersion__c = '0';
            updateOpportunity.APILastModifiedName__c = 'Lead Data';
            
            result.newOpps.put(key, updateOpportunity);
        }
        
        return result;
    }
////////////////////////////////////////////////////////////////////////////////
}
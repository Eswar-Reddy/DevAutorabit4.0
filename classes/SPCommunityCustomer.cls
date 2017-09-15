/*
* SPCommunityCustomer
* Purpose: Base class for the portal UI rework (A2 app)
* Created: Q3 2017
* Test(s): 
* CommunityNewAccount_Test
* SPCommunityCustomer_Test
* 
*/

public with sharing class SPCommunityCustomer {
    
    /*Static Constants*/
    @TestVisible
    private static String COMMERCIAL = 'Commercial';
    @TestVisible
    private static String HOME_OWNER = 'Home Owner';


    /*Variables*/

    /*Constructor*/
    public SPCommunityCustomer() { }


    /*
    * SHARED METHODS
    * createNewCustomer - new account/opp/contact creation for portal
    * getRecordHistory - returns object history related list from any parent id
    * 
    * 
    * 
    */

    //Create new customer - both cvar and rvar methods are in here
    @RemoteAction
    public static ResultMessage createNewCustomer(CommunityNewAccount.NewCustomer inputs) {
        return CommunityNewAccount.createNewCustomer(inputs);
    }

    //Get Record History
    @RemoteAction
    public static ResultMessage getRecordHistory(String parentId) {
        return SPCommunityRecordHistoryUtil.getRecordHistory(parentId);
    }
    
    @RemoteAction
    public static ResultMessage getNotesAndAttachments(String[] parentIds) {
        ResultMessage message = new ResultMessage();
        message.success = false;
        
        if(parentIds == null || parentIds.isEmpty()) {
            message.err = SPCommunityErrorUtility.invalidParams;
            return message;
        }
        
        try { 
            //return a list of attachments related to parentIds and to documents that are related to same parentIds        
            //1. get list of document ids related to parentIds
            List<String> docsIdList = new List<String>();
            
            for(Document__c d: [SELECT Id
                                FROM Document__c
                                WHERE Account__c =: parentIds
                                OR Opportunity__c =: parentIds]) {
                docsIdList.add(d.Id);
            } 
            
            //2. add this list of ids to the parentIds list
            parentIds.addAll(docsIdList);        
            
            //3. create payload of attachments
            Map<String, Object> subMap = new Map<String, Object>();

            subMap.put('attachments', [SELECT Id, Name, ParentId, CreatedDate, CreatedById, CreatedBy.FirstName, CreatedBy.LastName,
                                                          LastModifiedById, LastModifiedBy.FirstName, LastModifiedBy.LastName,
                                                          Owner.FirstName, Owner.LastName
                                                   FROM Attachment
                                                   WHERE ParentId =: parentIds
                                                   ORDER BY ParentId]);

            //get notes
            subMap.put('notes', [SELECT Id, ParentId, Title, Body, OwnerId, CreatedDate, CreatedById, 
                                                     CreatedBy.FirstName, CreatedBy.LastName, LastModifiedDate, LastModifiedById,
                                                     LastModifiedBy.FirstName, LastModifiedBy.LastName,
                                                     Owner.FirstName, Owner.LastName
                                             FROM Note WHERE ParentId IN: parentIds
                                             ORDER BY ParentId]);
            Object recordsObj = (Object)subMap;
            message.payloadMap.put('records', recordsObj);
            message.success = true;
        } catch(Exception e) {
            message.err = JSON.deserializeUntyped(SPCommunityErrorUtility.generateExceptionJSON(e));
        }
        return message;
    }
    



    /*
    * CVAR METHODS
    * getSiteList - new account/opp/contact creation for portal
    * getUserPermissions - returns object history related list from any parent id
    * getUserPermissionsEx - 
    * getModuleInverterList - 
    * createSystemOnlyDesign - 
    * getOpportunitySystems - 
    * 
    */

    //Get Sites/Designs
    @RemoteAction
    public static ResultMessage getSiteList(String opportunityId) {
        return CommercialDataUtility.getDesignSummary(opportunityId);
    }

    //Get User and Record level permissions
    @RemoteAction
    public static ResultMessage getUserPermissionsEx(String accountId, String opportunityId) { //
        return CommercialDataUtility.getPermissions(accountId, opportunityId);
    }

    //return System/Design setup Design Type/Modle/Inverter dependency
    @RemoteAction
    public static ResultMessage getModuleInverterList() {
        return CommercialDataUtility.getModuleInverterList();
    }

    @RemoteAction
    public static ResultMessage createSystemOnlyDesign(Design__c design, List <SunPower_Design_Item__c> inverters) {
        return CommercialDataUtility.createSystemOnlyDesign(design, inverters);
    }

    @RemoteAction
    public static ResultMessage getOpportunitySystems(String opportunityId) {
        return CommercialDataUtility.getOpportunitySystems(opportunityId);
    }

    /*RVAR METHODS
    * 
    * 
    * 
    * 
    * 
    */




    /*
    * Misc. Methods
    * getOwnerList - returns list of Active, Not Terminated partner contacts for owner changes
    * 
    * 
    * 
    */

    //Fetch eligible contacts for owner replacement
    @RemoteAction
    public static ResultMessage getOwnerList() {
        ResultMessage message = new ResultMessage();
        message.success = false;

        if(String.isNotBlank(UserInfo.getUserType()) && !UserInfo.getUserType().containsIgnoreCase('partner')) {
            message.err = SPCommunityErrorUtility.unauthorizedUser;
            return message;
        }

        try {
            Id partnerId = [SELECT Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;

            if(String.isBlank(partnerId)) {
                message.err = SPCommunityErrorUtility.unauthorizedUser;
                return message;
            }
            message.payloadMap.put('records', [SELECT Id, FirstName, LastName
                                               FROM User Where Contact.AccountId =: partnerId
                                               AND isActive = true AND Contact.Terminated__c = false
                                               ORDER BY FirstName ASC]);
            message.success = true;
        } catch(Exception e) {
            message.err = JSON.deserializeUntyped(SPCommunityErrorUtility.generateExceptionJSON(e));
        }
        return message;
    }

    /*
    * Metadata retrieval utilities
    * getDependentPicklist - returns picklist dependency from custom metadata  
    * getOpportunityPicklists - returns picklists by record type for opportunity from the account type (new account creation page)
    * getObjectPicklists - returns picklists by record type from an sObjectString - requires mapping
    * BASE: MetadataRetrievalUtil.retrievePicklistsForRecordType with string sObjectType and string array of record type ids
    */
    @RemoteAction
    public static DependentPicklistHandler.CustomDependentPicklist getDependentPicklist(String controllingFieldName) {
        return DependentPicklistHandler.getPicklistDependency(controllingFieldName);
    }

    //Takes in account type from new account page params
    @RemoteAction
    public static ResultMessage getOpportunityPicklists(String accountType) {
        ResultMessage message = new ResultMessage();
        message.success = false;

        if(String.isBlank(accountType)) {
            message.message = SPCommunityErrorUtility.invalidParams;
            return message;
        }
        String[] recTypeIds = new String[]{};
        if(accountType == COMMERCIAL)
            recTypeIds.add(SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get(COMMERCIAL));
        else 
            recTypeIds.add(SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get('Home_Owner'));

        return MetadataRetrievalUtil.retrievePicklistsForRecordType('Opportunity', recTypeIds);

    }

    //get specific picklists from string object type - uses string to id mapping
    @RemoteAction
    public static ResultMessage getObjectPicklists(String objectType) {
        ResultMessage message = new ResultMessage();
        message.success = false;

        if(String.isBlank(objectType)) {
            message.message = SPCommunityErrorUtility.invalidParams;
            return message;
        }
        Map<String,Id> recTypeMap = MetadataRetrievalUtil.getRecordTypeMap();
        if(recTypeMap == null || recTypeMap.isEmpty() || !recTypeMap.containsKey(objectType) || recTypeMap.get(objectType) == null) {
            message.message = SPCommunityErrorUtility.invalidParams;
            return message;
        }
        String[] recTypeIds = new String[]{recTypeMap.get(objectType)};

        return MetadataRetrievalUtil.retrievePicklistsForRecordType(objectType, recTypeIds);

    }
    
    

    /*
    * Private methods
    * 
    *
    *
    */
    
}
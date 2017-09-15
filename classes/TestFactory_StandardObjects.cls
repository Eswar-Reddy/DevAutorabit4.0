@isTest
public class TestFactory_StandardObjects {

	//---------------------------- User --------------------------------

	//regular User
	//partner user
    private static User partnerUser;
    private static User internalUser;

    public static User getPartnerUser(){
        if(partnerUser == NULL){
            partnerUser = createPartnerUser(NULL, NULL);
            insert partnerUser;
        }
        return partnerUser;
    }

    public static User createPartnerUser(Id contactId, Id profileId) {
        if(contactId == null) contactId = createPartnerContact(null).Id;
        if(profileId == NULL) profileId = [SELECT Id FROM Profile WHERE Name = 'Partner Executive' LIMIT 1].Id;
        
        User u = (User)SmartFactory.createSObject('User', false);
        u.ProfileId = profileId;
        u.contactId = contactId;

        return u;
    }

    public static User getInternalUser(){
        if(internalUser == NULL){
            internalUser = createInternalUser(NULL, NULL);
            insert internalUser;
        }
        return internalUser;
    }

    public static User createInternalUser(Id userRoleId, Id profileId){
        if(userRoleId == NULL)  userRoleId = [SELECT Id FROM UserRole WHERE Name LIKE '%SunPower' LIMIT 1].Id;
        if(profileId == NULL)   profileId = [SELECT Id FROM Profile WHERE Name = 'SunPower User' LIMIT 1].Id;

        User u = (User)SmartFactory.createSObject('User', false);
        u.ProfileId = profileId;
        u.UserRoleId = userRoleId;

        return u;
    }

	//---------------------------- Account --------------------------------
    private static Account residentialCustomerAccount;
    private static Account commercialCustomerAccount;
    private static Account partnerAccount;
    private static Account installerAccount;


    public static Account getResidentialCustomerAccount(){
        if(residentialCustomerAccount == NULL){
            Account a = createResidentialCustomerAccount();
            insert a;
            residentialCustomerAccount = a;
        }
        return residentialCustomerAccount;
    }

    public static Account createResidentialCustomerAccount(){
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
        
        Account a = (Account)SmartFactory.createSObject('Account', false);
        a.RecordTypeId = recTypeId;
        return a;
    }

    public static Account getCommercialCustomerAccount(){
        if(commercialCustomerAccount == NULL){
            Account a = createCommercialCustomerAccount();
            insert a;
            commercialCustomerAccount = a;
        }
        return commercialCustomerAccount;
    }

    public static Account createCommercialCustomerAccount(){
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
        
        Account a = (Account)SmartFactory.createSObject('Account', false);
        a.RecordTypeId = recTypeId;
        return a;
    }

    public static Account getPartnerAccount(){
        if(partnerAccount == NULL){
            Account a = createPartnerAccount();
            insert a;
            partnerAccount = a;
        }
        return partnerAccount;
    }

    public static Account getInstallerAccount(){
    	if(installerAccount == NULL){
    		Account a = createPartnerAccount();
    		insert a;

    		Bill_To_Site__c bts = TestFactory_Ordering.createBillToSite(a.Id);
            bts.Site_ID__c = string.valueof(math.roundtolong(math.random()*1000000));
            bts.Oracle_Operating_Unit_Code__c = 'SPEB OU';
    		insert bts;

    		Ship_to_Site__c sts = TestFactory_Ordering.createDealerWarehouseShipToSite(a.Id);
            sts.Status__c = 'Active';
            sts.SiteID__c = string.valueof(math.roundtolong(math.random()*1000000));
            sts.Oracle_Operating_Unit__c = 'SPNA OU';
    		insert sts;

    		a.Default_Dealer_Warehouse_Shipping_Site__c = sts.Id;
    		update a;

    		installerAccount = a;
    	}
    	return installerAccount;
    }

    public static Account createPartnerAccount(){
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        
        Account a = (Account)SmartFactory.createSObject('Account', false);
        a.RecordTypeId = recTypeId;
        return a;
    }

    public static AccountContactRole createAccountContactRole() {
        return (AccountContactRole)SmartFactory.createSObject('AccountContactRole');
    }

    //---------------------------- Contact --------------------------------
    private static Contact partnerContact;
    private static Contact customerContact;

    public static Contact getPartnerContact(){
        if(partnerContact == NULL){
            Contact c = createPartnerContact(NULL);
            insert c;
            partnerContact = c;
        }
        return partnerContact;
    }

    public static Contact createPartnerContact(Id partnerId){
        if(partnerId == NULL) partnerId = getPartnerAccount().Id;
        
        String recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        
        Contact c = (Contact)SmartFactory.createSObject('Contact', false);
        c.RecordTypeId 	= recTypeId;
        c.AccountId 	= partnerId;
        return c;
    }

    public static Contact getCustomerContact(){
        if(customerContact == NULL){
            Account a = getResidentialCustomerAccount();
            
            String recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            
            Contact c = (Contact)SmartFactory.createSObject('Contact', false);
            c.AccountId = a.Id;
            insert c;
            customerContact = c;
        }
        return customerContact;
    }

    public static Contact createCustomerContact(Id aId){
        if(aId == NULL) aId = getResidentialCustomerAccount().Id;
        
        String recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Contact c = (Contact)SmartFactory.createSObject('Contact', false);
        c.RecordTypeId 	= recTypeId;
        c.AccountId 	= aId;
        return c;
    }

    //---------------------------- Opportunity --------------------------------
    private static Opportunity homeOwnerOpportunity;

    public static Opportunity getHomeOwnerOpportunity(){
        if(homeOwnerOpportunity == NULL){
            Opportunity o = createHomeOwnerOpportunity(NULL, NULL);
            insert o;
            homeOwnerOpportunity = o;
        }
        return homeOwnerOpportunity;
    }

    public static Opportunity createHomeOwnerOpportunity(Id accId, Id partnerAccId){
        if(accId == NULL) 			accId 			= getResidentialCustomerAccount().Id;
        if(partnerAccId == NULL) 	partnerAccId 	= getPartnerAccount().Id;
        
        String recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        
        Opportunity o = (Opportunity)SmartFactory.createSObject('Opportunity',false);
        o.RecordTypeId 			= recTypeId;
        o.AccountId 			= accId;
        o.Partner_Account_Id__c = partnerAccId;
        return o;
    }

    private static Opportunity cvarOpportunity;
    
    public static Opportunity getCvarOpportunity(){
        if(cvarOpportunity == NULL){
            Opportunity o = createCvarOpportunity(NULL, NULL);
            insert o;
            cvarOpportunity = o;
        }
        return cvarOpportunity;
    }

    public static Opportunity createCvarOpportunity(Id accId, Id partnerAccId){
        if(accId == NULL)           accId           = getResidentialCustomerAccount().Id;
        if(partnerAccId == NULL)    partnerAccId    = getPartnerAccount().Id;
        
        String recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
        
        Opportunity o = (Opportunity)SmartFactory.createSObject('Opportunity',false);
        o.RecordTypeId          = recTypeId;
        o.AccountId             = accId;
        o.Partner_Account_Id__c = partnerAccId;
        o.Installation_Date__c = Date.today().addDays(30);
        o.Commercial_Operation_Date__c = Date.today().addDays(90);
        o.Facility_State1__c = SmartFactory.DefaultState;
        return o;
    }

    //---------------------------- Quote -------------------------------- 
    private static Quote proposalQuote;

    public static Quote getProposalQuote(){
        if(proposalQuote == NULL){
            Quote q = createProposalQuote(NULL);
            insert q;
            proposalQuote = q;
        }
        return proposalQuote;
    }

    public static Quote createProposalQuote(Id oId){
        if(oId == NULL) oId = getHomeOwnerOpportunity().Id;
        
        String recTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Proposal Quote').getRecordTypeId();
        
        Quote q = (Quote)SmartFactory.createSObject('Quote',false);
        q.RecordTypeId 	= recTypeId;
        q.OpportunityId = oId;
        return q;
    }

    //---------------------------- Campaign --------------------------------
    private static Campaign testCampaign;

    public static Campaign getTestCampaign(){
        if(testCampaign == NULL){
            Campaign c = createTestCampaign();
            insert c;
            testCampaign = c;
        }
        return testCampaign;
    }

    public static Campaign createTestCampaign(){
        Campaign camp = (Campaign)SmartFactory.createSObject('Campaign', false);
        return camp;
    }

}
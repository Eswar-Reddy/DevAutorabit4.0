public class CommunityNewAccount {

    @TestVisible
    private static String errMessage = 'There is a problem with the system. Please contact Digital Support';
    @TestVisible
    private static ResultMessage message {get;set;}
    @TestVisible
    private static String COMMERCIAL = 'Commercial';
    @TestVisible
    private static String HOME_OWNER = 'Home Owner';
    
    @RemoteAction
    public static ResultMessage createNewCustomer(NewCustomer inputs) { //TODO: Inbound here

        message = new ResultMessage();
        message.success = false;

        //TEMP TEST
        //NewCustomer inputs = getTestNewCustomer();
        message.payloadMap.put('inbound', inputs);
        NewCustomer outputs = getPopulatedCustomer(inputs);     
        message.payloadMap.put('parsedPayload', outputs);
        
        //Variable Collection
        Account newCustomer = new Account();
        if(outputs.newAccount != null) newCustomer = outputs.newAccount;
        
        Opportunity opp = new Opportunity();
        if(outputs.newOpp != null) opp = outputs.newOpp;

        Contact contact = new Contact();
        if(outputs.newContact != null) contact = outputs.newContact;

        Site_Information_Form__c site = new Site_Information_Form__c();
        if(outputs.newSite != null) site = outputs.newSite;
        
        OpportunityContactRole ocr = new OpportunityContactRole();

        //statics
        String ACTIVE = 'Active';
        String DEFAULT_BUSINESS_UNIT = 'RLC';
        String O_CUSTOMER_CLASSIFICATION = 'LEASE_CUSTOMER';
        String O_ACCOUNT_TYPE = 'R';
        String O_SALES_CHANNEL = 'RVAR LEASE';
        String O_OPERATING_UNIT = 'SPEB OU';
        String O_ORDER_TYPE = 'SPEB RVAR Lease 2';
        Id commercialOppRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get(COMMERCIAL);
        Id commercialAccRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Account.sObjectType).get(COMMERCIAL);
        Id resiOppRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get('Home_Owner');
        Id resiAccRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner');
        Id siteRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Site_Information_Form__c.sObjectType).get('Standard_Site');
        
        //queries
        User partnerUser= [SELECT UserType, Country_Domain__c, Profile.Name, IsPortalEnabled, Quote_Creation_Allowed__c,
                                 Contact.Account.Primary_PSR__c, Contact.AccountId, Contact.Account.Country_Domain__c, Contact.Account.Name,
                                 Contact.Account.Theater__c, Contact.Account.Lease2_0_Program_Partner__c, Contact.Account.Oracle_Warehouse__c, 
                                 Contact.Account.Oracle_Vendor_Number__c, Contact.Account.Oracle_Vendor_Site_Code__c,
                                 Contact.Account.BillingCountry, Contact.Account.BillingCity, Contact.Account.BillingStreet, Contact.Account.BillingState, 
                                 Contact.Account.BillingPostalCode, Contact.Account.CurrencyIsoCode, Contact.Contact_Language__c, Contact.Account.Contact_Language__c                              
                           FROM User 
                           WHERE ID =: Userinfo.getUserId()];

        if(partnerUser.ContactId == null) {
            message.err = SPCommunityErrorUtility.unauthorizedUser;
            return message;
        }
        Account partnerAccount = partnerUser.Contact.Account;
        
        if(partnerAccount == null || partnerAccount.Id == null) {
            message.err = SPCommunityErrorUtility.unauthorizedUser;
            return message;
        }

        /*BEGIN PROCESSING*/

        //Set defaults for all
        //Opportunity
        opp.Name = newCustomer.Name;
        opp.OwnerId = partnerUser.Id;
        opp.Partner_Account_Id__c = partnerAccount.Id;
        opp.Theater__c = partnerAccount.Theater__c;
        opp.Lead_Manufacturer__c = 'Partner';
        opp.Opportunity_Status__c = ACTIVE;
        opp.Partner_Portal_Registration__c = true;
        
        //OPP TODO: 
        //REFERRALS? for residential only?
        
        //Contact
        contact.Contact_Language__c = partnerAccount.Contact_Language__c;
        contact.Partner_Portal_Registration__c = true;
        contact.Primary__c = true;
        contact.LastName = 'Test';

        //CONTACT TODO: Address fields; done in NewCustomer constructor?
        //contact.Preferred_Language_Code__c = prefLangSelected; - TODO: This is from UI, not in mockups - Pending

        //Account
        newCustomer.Partner_Account__c = partnerAccount.Id;
        newCustomer.Override_Duplicate_Check__c = true; //ONLY FOR NOW TODO: Remove this
        newCustomer.Status__c = ACTIVE;
        newCustomer.Theater__c= partnerAccount.Theater__c;
        newCustomer.Partner_Portal_Registration__c = true;
        newCustomer.BillingCountry = partnerAccount.BillingCountry;
        newCustomer.Oracle_Vendor_Number__c = partnerAccount.Oracle_Vendor_Number__c;
        newCustomer.Oracle_Vendor_Site_Code__c = partnerAccount.Oracle_Vendor_Site_Code__c;
        newCustomer.Contact_Language__c = partnerAccount.Contact_Language__c;
        //ACCOUNT TODO: RSM, CRSM, etc.
        
        //TODO: Determine Recordtype mapping on inbound
        if(inputs.accountType == COMMERCIAL) {
            //opp fields
            opp.StageName = '12% - Qualified Opportunity';
            opp.Project_Stage__c = getDefaultProjectStage(); //'Qualification in Process';
            opp.Business_Unit__c = DEFAULT_BUSINESS_UNIT; 
            opp.RLC_Type__c = 'Light Commercial';
            opp.RecordTypeId = commercialOppRecTypeId;
            opp.Count_of_Sites__c= 1;
            opp.Opportunity_Status__c = 'Qualified';
            //TODO: Installation_Date__c, Commercial_Operation_Date__c, Country__c, Facility Address; done in NewCustomer constructor?

            //account fields
            newCustomer.Type = COMMERCIAL;
            newCustomer.RecordTypeId = commercialAccRecTypeId;
            newCustomer.Number_of_Sites__c = 1;
            newCustomer.Number_of_Active_Sites__c = 1;

            site.Site_Status__c= ACTIVE;
            site.Site_Name__c = opp.Name;
        }
        else { 
            //opp fields
            opp.Business_Unit__c = DEFAULT_BUSINESS_UNIT; 
            opp.RLC_Type__c = 'Residential';
            opp.StageName= 'New Opportunity';
            newCustomer.RecordTypeId = resiAccRecTypeId;
            opp.RecordTypeId = resiOppRecTypeId;
            

            //acc fields
            newCustomer.Type = HOME_OWNER;
            newCustomer.RecordTypeId = resiAccRecTypeId;
            newCustomer.Oracle_Customer_Classification__c = O_CUSTOMER_CLASSIFICATION;
            newCustomer.Oracle_Warehouse__c = partnerAccount.Oracle_Warehouse__c;
            newCustomer.Oracle_Account_Type__c =O_ACCOUNT_TYPE;
            newCustomer.Oracle_Sales_Channel__c = O_SALES_CHANNEL;
            newCustomer.Oracle_Operating_Unit__c = O_OPERATING_UNIT;
            newCustomer.Oracle_Order_Type__c = O_ORDER_TYPE;

            //TODO: Create Opportunity Contact Role
            /*
            OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.IsPrimary= true;
                ocr.ContactId= contact.Id; --> put in try catch section of DML section below, if contact id != null
                ocr.OpportunityId= newOpp.Id;
                ocr.Role= 'Borrower';
            insert ocr; --> put in DML section below (make a call to createResult, passing ocr)
                        
            ocr.IsPrimary= true;
            ocr.Role= 'Borrower';
            */
        }

        //BEGIN DML//
        Savepoint sp = Database.setSavepoint();
        Database.SaveResult result;
        try {
            Id accResultId;
            Id oppResultId;
            Id contactResultId;

            result = createResult(newCustomer);
            if(result == null || !result.isSuccess()) {
                Database.Rollback(sp);
            } else {
                accResultId = result.getId();
                contact.AccountId = accResultId;
                result = createResult(contact);
                if(result == null || !result.isSuccess()) {
                    Database.Rollback(sp);
                } else {
                    contactResultId = result.getId();
                    opp.Primary_Contact__c = contactResultId;
                    opp.AccountId = accResultId;
                    result = createResult(opp);
                    if(result == null || !result.isSuccess()) {
                        Database.Rollback(sp);
                    } else {
                        oppResultId = result.getId();
                        //commercial only
                        if (inputs.accountType == COMMERCIAL){ 
                            site.Opportunity_del__c = oppResultId;
                            site.Account__c = accResultId;
                            result = createResult(site);
                        } else {
                            ocr.OpportunityId= oppResultId;
                            ocr.ContactId = contactResultId;
                            result = createResult(ocr);
                        }
                        if(result == null || !result.isSuccess()) {
                            Database.Rollback(sp);
                        } else {
                            message.success = true;
                            message.payloadMap.put('AccountId', accResultId); //TODO: Combine these
                            message.payloadMap.put('OpportunityId', oppResultId);
                            message.payloadMap.put('ContactId', contactResultId);
                        }
                    }
                }
            }
        } catch(Exception e) {
            //rollback
            message.err = JSON.deserializeUntyped(generateExceptionJSON(e));
            Database.Rollback(sp);
        }
        return message;
    }

    private static Database.SaveResult createResult(sObject newObject) {    

        Database.SaveResult result;

        if(newObject == null) return result;

        try {
            result = Database.insert(newObject);
        } catch(DmlException dx) {
            message.err = JSON.deserializeUntyped(generateDMLExceptionJSON(dx));
        } catch(Exception e) {
            message.err = JSON.deserializeUntyped(generateExceptionJSON(e));
        }
        return result;
    }

    private static String generateExceptionJSON(Exception e) {
        return SPCommunityErrorUtility.generateExceptionJSON(e);
    }

    private static String generateDMLExceptionJSON(DMLException e) {
        return SPCommunityErrorUtility.generateDMLExceptionJSON(e);
    }

    //Metadata retrieval utilities
    @RemoteAction
    public static DependentPicklistHandler.CustomDependentPicklist getDependentPicklist(String controllingFieldName) {
        return DependentPicklistHandler.getPicklistDependency(controllingFieldName);
    }

    @RemoteAction
    public static ResultMessage getOpportunityPicklists(String accountType) {
        message = new ResultMessage();
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

        message = MetadataRetrievalUtil.retrievePicklistsForRecordType('Opportunity', recTypeIds);
        return message;

    }

    private static String getDefaultProjectStage() {
        String DEFAULT_PROJECT_STAGE = '';
        //Opp Default Project Stage
        List<Schema.Picklistentry> projectStages = Opportunity.Project_Stage__c.getDescribe().getPicklistValues();   
        for (Schema.Picklistentry picklistentry : projectStages) {
            if (picklistentry.isActive() == true && picklistentry.isDefaultValue() == true) {
                DEFAULT_PROJECT_STAGE = picklistentry.getValue();
                break;
            }
        }

        return DEFAULT_PROJECT_STAGE;
    }

    public class NewCustomer {
        public String accountType {get;set;}
        public String accountName {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String phone {get;set;}
        public Decimal latitude {get;set;}
        public Decimal longitude {get;set;}
        public String street {get;set;}
        //public String street2 {get;set;} - TODO: Check how this currently functions
        public String state {get;set;}
        public String city {get;set;}
        public String postalCode {get;set;}
        public String country {get;set;}
        public String industry {get;set;}
        public String vertical {get;set;}
        public Date closeDate {get;set;}
        public Date installationDate {get;set;}
        public Date codDate {get;set;}
        public String dealType {get;set;}
        public Account newAccount {get;set;}
        public Contact newContact {get;set;}
        public Opportunity newOpp {get;set;}
        public Site_Information_Form__c newSite  {get;set;}
        //public String Lead_Referral_Name {get; set;}

        public NewCustomer() { /*CONSTRUCTOR*/ }
        
        public NewCustomer(NewCustomer inputs) {  
            
            this.newAccount = new Account();
            newAccount.Name = inputs.accountName;
            newAccount.Email__c = inputs.email;
            newAccount.Phone = inputs.phone;
            newAccount.BillingStreet = inputs.street;
            newAccount.BillingCity = inputs.city;
            newAccount.BillingState = inputs.state;
            newAccount.BillingPostalCode = inputs.postalCode;
            newAccount.BillingCountry = inputs.country;
            newAccount.ShippingStreet = inputs.street;
            newAccount.ShippingCity = inputs.city;
            newAccount.ShippingState = inputs.state;
            newAccount.ShippingPostalCode = inputs.postalCode;
            newAccount.ShippingCountry = inputs.country;
            newAccount.Key_Vertical__c = inputs.vertical;
            newAccount.Industry = inputs.industry;
            newAccount.Geolocation__Latitude__s = inputs.latitude;
            newAccount.Geolocation__Longitude__s = inputs.longitude;
            newAccount.Lat__c = inputs.latitude;
            newAccount.Log__c = inputs.longitude;
            newAccount.BillingLatitude = inputs.latitude;
            newAccount.BillingLongitude = inputs.longitude;            

            this.newContact = new Contact();
            newContact.Email = inputs.email;
            newContact.Phone = inputs.phone;
            newContact.MailingStreet = inputs.street;
            newContact.MailingCity = inputs.city;
            newContact.MailingState = inputs.state;
            newContact.MailingPostalCode = inputs.postalCode;
            newContact.MailingCountry = inputs.country;
            newContact.FirstName = inputs.firstName;
            newContact.LastName = inputs.lastName;

            this.newOpp = new Opportunity();
            newOpp.CloseDate = inputs.closeDate;            

            //Commercial Only
            if(inputs.accountType == COMMERCIAL) {
                newAccount.Facility_City__c = inputs.city;
                newAccount.Facility_Address__c = inputs.street;
                newAccount.Facility_State__c = inputs.state;
                newAccount.Facility_Zip__c = inputs.postalCode;
                

                newOpp.Installation_Date__c = inputs.installationDate;
                newOpp.Commercial_Operation_Date__c = inputs.codDate;
                newOpp.Facility_City1__c = inputs.city;
                newOpp.Facility_Address1__c = inputs.street;
                newOpp.Facility_State1__c = inputs.state;
                newOpp.Facility_Zip1__c = inputs.postalCode;
                newOpp.Country__c = inputs.country;
                newOpp.Contract_Type__c = inputs.dealType;

                this.newSite = new Site_Information_Form__c();
                newSite.Site_Address__c = inputs.street;
                newSite.Site_State__c = inputs.state;
                newSite.Site_City__c = inputs.city;
                newSite.Site_Zip_Postal_Code__c = inputs.postalCode;
                newSite.Site_Country__c = inputs.country;
                newSite.Site_Latitude_Y_coordinate__c = inputs.latitude == null ? '' : String.valueOf(inputs.latitude);
                newSite.Site_Longitude_X_coordinate__c = inputs.longitude == null ? '' : String.valueOf(inputs.longitude);
            } /*else {
                //referrals
                //newOpp.Lead_Referral_Name__c = inputs.Lead_Referral_Name;
            }*/
            
        }
    }

    private static NewCustomer getPopulatedCustomer(NewCustomer inputs) {
        return new NewCustomer(inputs);
    }

}
/********************************************************************************************
Name   : AccountExtension
Author : Anjali Jain
Date   : Sept 10, 2011
Related Case : 
Usage  : Controller of VF page CustomOpportunity to create opportunity in case of Partner users.
Edits  :    
        2011-10-27  feature     Troy Conquer    Bluewolf        Add lease checkbox logic and validate user's ability to create lease orders
        2011-10-31  feature     Troy Conquer    Bluewolf        Autocreated shipto/billto records when save is clicked
        2011-11-02  feature     Troy Conquer    Bluewolf        Navigate to leaseorderwizard on save, if lease is checked.
                                                                Address verification logic
        2012-03-29  feature     Troy Conquer    Bluewolf        Route Lease user to CprIntegration page
/***    Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013, to implement TPO FR account,opportunity & contact creation for partner users 
        2016-09-01 -- Commercial workstream: Pivotal #129544575 WW39 - 2016 PO: Miltos Vratimos
            Crystal - Modified to remove site creation for residential and add only for commercial attaching to both account and opportunity

===============
CHANGE HISTORY:
===============

version: KCM_06082016
author: Kane Chelster Macaspac
last date/time modified: 06/08/2016 3:56 PM Pacific
details:
1. A request to delete the field How_did_you_hear_about_us__c in case 00729568 was made.  However, the field is referenced in this Apex
   class and as well as in the Visualforce page EditResidentialAccount.  In order to delete the field, it must first be removed from this
   class and the VF page.
2. The requester has identified that the field hear_about_us__c in opportunity should be the replacement field in the code.
3. Use the version name above to search this document for the specific changes in code related to the details described.
********************************************************************************************/

public with sharing class AccountExtension 
{
/******* VARIABLES : start *******/

    public static final String RECORD_TYPE_KEY = 'RecordType';
    public static final String O_CUSTOMER_CLASSIFICATION = 'LEASE_CUSTOMER';
    public static final String O_ACCOUNT_TYPE = 'R';
    public static final String O_SALES_CHANNEL = 'RVAR LEASE';
    public static final String O_OPERATING_UNIT = 'SPEB OU';
    public static final String O_ORDER_TYPE = 'SPEB RVAR Lease 2';
    
    private final ApexPages.StandardController controller;
    
    private static String COMMERCIAL = 'Commercial';
    private static String HOME_OWNER = 'Home Owner';
    private User user;  
    
    //KM_04042017: state picklist; #142338539 
    public List<SelectOption> stateOption {
        get {
            if(stateOption == null) {
                stateOption = new List<SelectOption>();
                stateOption.add(new SelectOption('', ''));
                for(Schema.PicklistEntry p : SalesConfiguration__c.State__c.getDescribe().getPicklistValues()) {
                    stateOption.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return stateOption;
        }
        set;
    }
    
/******** VARIABLES : end ********/

/******* PROPERTY : start *******/
    public String prefLangSelected { get; set; } //Added for Pivotal ## 122893781
    public String propPortalUsrId { get; set; } ///ADDED on 24 March-2014
    public String retURL {get; set;}
    public String recType {get; set;}
    public String accId {get; set;}
    public String isEdit {get; set;}
    public Opportunity opp {get; set;}
    public Opportunity newOpp {get; set;}
    public String businessRegParameter {get;set;}
    public Contact contact {get; set;}
    public Account newCustomer {get; set;}
    public Account partnerAccount {get; set;}
    public String normalRedirectUrl {get; set;}
    public Boolean isEUProfile {get; set;} 
    public Decimal latitude {get; set;}
    public Decimal longitude {get; set;}
    public Boolean isLeaseEnabledPartner {
        get{
            Boolean leaseEnabled = false;           
            if ( partnerUser != null )
                leaseEnabled =  partnerUser.Contact.Account.Lease2_0_Program_Partner__c; 
            return leaseEnabled;
        }
    }
    public Boolean validatedAddress {get; set;}

    public static Id commercialRecordTypeId {get; set;}
    public static Id residentialRecordTypeId {get; set;}
    public static Id commercialCustomerRecordTypeId {get; set;}
    public static Id residentialCustomerRecordTypeId{get; set;}
    public static Id siteRecordTypeId {get; set;}
    
    public static User partnerUser {get;set;}
    public string OracleCOunty {get;set;}
    
    public Id recTypeId {get; set;} 
    public String userCountry {get; set;}
    
    public User getUser(){  return user; }
    
    public Boolean validateCountryFrance {get; set;}    
    public boolean getCountry(){ return validateCountry(); }
    public boolean showSaveandQuoteBtn {get;set;}

    //Added for Pivotal ## 122893781
    public List<SelectOption> getPrefLangs() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('EN','English'));
        options.add(new SelectOption('ES','Spanish'));
        options.add(new SelectOption('DE','German'));
        options.add(new SelectOption('FR','French'));
        options.add(new SelectOption('IT','Italian'));            
        options.add(new SelectOption('NL','Dutch'));
        return options;
    }
    
/******** PROPERTY : end ********/

/******* STATIC BLOCK : start *******/

    static
    {
        if(UserInfo.getUserType() == 'PowerPartner') {
            partnerUser= [SELECT UserType, User.CPR_Salesperson_ID__c, Profile.Name, IsPortalEnabled, Quote_Creation_Allowed__c,
                                 Contact.Account.CRSM__c,
                                 Contact.Account.Primary_PSR__c, Contact.AccountId, Contact.Account.Country_Domain__c, Contact.Account.Name,
                                 Contact.Account.Theater__c, Contact.Account.Lease2_0_Program_Partner__c, Contact.Account.Oracle_Warehouse__c, 
                                 Contact.Account.Oracle_Vendor_Number__c, Contact.Account.Oracle_Vendor_Site_Code__c,
                                 Contact.Account.BillingCountry, Contact.Account.BillingCity, Contact.Account.BillingStreet, Contact.Account.BillingState, 
                                 Contact.Account.BillingPostalCode, Contact.Account.CurrencyIsoCode, Contact.Contact_Language__c, Contact.Account.Contact_Language__c                                 
                           FROM User 
                           WHERE ID =: Userinfo.getUserId()];
        }
        setRecordTypes();//for Case# 00087129
    }//End static

    private static void setRecordTypes() 
    {
        for(RecordType recType: [SELECT Id, Name, sobjectType  
                                 FROM RecordType  
                                 WHERE (Name IN ('Commercial','Home Owner') AND sobjectType= 'Opportunity') OR
                                       (Name IN ('Commercial Customer','Residential Customer') AND sobjectType= 'Account') OR
                                       (Name IN ('Standard Site') AND sobjectType= 'Site_Information_Form__c')]) 
        {
            if(recType.Name == 'Commercial' && recType.sobjectType == 'Opportunity') 
                commercialRecordTypeId= recType.Id;
            else if(recType.Name == 'Home Owner' && recType.sobjectType == 'Opportunity')
                residentialRecordTypeId= recType.Id;
            else if(recType.Name == 'Commercial Customer' && recType.sobjectType == 'Account')
                commercialCustomerRecordTypeId= recType.Id;
            else if(recType.Name == 'Residential Customer' && recType.sobjectType == 'Account')
                residentialCustomerRecordTypeId= recType.Id;
            else if(recType.Name == 'Standard Site' && recType.sobjectType == 'Site_Information_Form__c')
                siteRecordTypeId= recType.Id;
        }        
    }//End Func setRecordTypes
    
/******** STATIC BLOCK : end ********/

/****** CONSTRUCTOR : start ******/

    public AccountExtension(ApexPages.StandardController cont) 
    {
        if(switch__c.getValues('Quick Quote') !=null && switch__c.getValues('Quick Quote').Quote_Read_Only__c ==true){
            showSaveandQuoteBtn = false;
        }
        else{
            showSaveandQuoteBtn = true;
        }
        propPortalUsrId = UserInfo.getUserId(); //Added by Amit Birlasoft on 24-03-2014
               validatedAddress = false;
               
        Boolean bValidatedCountry = validateCountry();
        
        retURL=    ApexPages.currentPage().getParameters().get('retURL');
        recTypeId= ApexPages.currentPage().getParameters().get(RECORD_TYPE_KEY);        
        accId=     ApexPages.currentPage().getParameters().get('id');
        isEdit=    ApexPages.currentPage().getParameters().get('isEdit');

        if(partnerUser.profile.Name.contains('EU'))
            isEUProfile = true;
        else
            isEUProfile = false;
        
        if(partnerUser != null)                         
            partnerAccount = partnerUser.Contact.Account;

        if(accId != null && isEdit != null && isEdit == 'Y')
            isEdit = 'Y';
        else
            isEdit = 'N';

        if(isEdit == 'N') 
        {
            opp = new Opportunity();
            newCustomer = new Account();
            contact = new Contact();
            
            if(partnerAccount != null) 
            {
                opp.Partner_Account_Id__c= partnerAccount.Id;
                opp.Theater__c= partnerAccount.Theater__c;
                newCustomer.Theater__c= partnerAccount.Theater__c;
                contact.Contact_Language__c= partnerAccount.Contact_Language__c;
                
                //Country should be defaulted to partner country
                newCustomer.BillingCountry = partnerAccount.BillingCountry;
                newCustomer.Oracle_Vendor_Number__c = partnerAccount.Oracle_Vendor_Number__c;
                newCustomer.Oracle_Vendor_Site_Code__c = partnerAccount.Oracle_Vendor_Site_Code__c;
                
                opp.Lead_Manufacturer__c = 'Partner';
                opp.OwnerId = partnerUser.Id;
                
                if((commercialCustomerRecordTypeId != null &&  commercialCustomerRecordTypeId == recTypeId) || 
                   (commercialRecordTypeId != null &&  commercialRecordTypeId == recTypeId)) 
                {
                    opp.StageName = '12% - Qualified Opportunity';
                    if(bValidatedCountry)
                        opp.CloseDate= date.today() + 60;
                        
                    opp.Project_Stage__c= 'Qualification in Process';
                    recType= COMMERCIAL;
                    newCustomer.RecordTypeId= commercialCustomerRecordTypeId;
                    opp.RecordTypeId= commercialRecordTypeId;
                    opp.Count_of_Sites__c= 1;
                }
                else if((residentialCustomerRecordTypeId != null &&  residentialCustomerRecordTypeId == recTypeId) || 
                        (residentialRecordTypeId != null &&  residentialRecordTypeId == recTypeId)) 
                {
                    recType = HOME_OWNER;
                    opp.Business_Unit__c= 'RLC'; 
                    opp.RLC_Type__c = 'Residential'; //kane macaspac 07/01/2015 07:23 PM PDT: added line as a resolution for CASE 00510690
                    opp.StageName= 'New Opportunity';
                    if(bValidatedCountry)
                        opp.CloseDate= date.today() + 60;
                        
                    newCustomer.RecordTypeId= residentialCustomerRecordTypeId;
                    opp.RecordTypeId= residentialRecordTypeId;
                }

                if(bValidatedCountry)
                {
                    recTypeId= residentialCustomerRecordTypeId;
                    opp.StageName= 'New Opportunity';
                    recType= HOME_OWNER;
                    opp.Business_Unit__c= 'RLC';
                    opp.RLC_Type__c = 'Residential'; //kane macaspac 07/01/2015 07:23 PM PDT: added line as a resolution for CASE 00510690
                    opp.CloseDate= date.today() + 60;
                    newCustomer.RecordTypeId= residentialCustomerRecordTypeId;
                    opp.RecordTypeId= residentialRecordTypeId;
                }
            }
        }
        else if (isEdit == 'Y') 
        {
            if(commercialCustomerRecordTypeId != null &&  commercialCustomerRecordTypeId == recTypeId)
                recType = COMMERCIAL;
            else if(residentialCustomerRecordTypeId != null &&  residentialCustomerRecordTypeId == recTypeId)
                recType = HOME_OWNER;
                
            populateOppAccountAndContactDetails(accId);           
        }           
    }//End Constructor AccountExtension
    
/******* CONSTRUCTOR : end *******/

/******* FUNCTION : start *******/

    //Returns true if LoggedIn User's country domain is France
    public Boolean validateCountry()
    {       
        validateCountryFrance = false;
        user = [SELEcT Id, Country, 
                       Username, Country_Domain__c 
                FROM User 
                WHERE id =: UserInfo.getUserId()];
        
      //  if(user.Country_Domain__c == System.Label.CountryDomain_FR)
       //New Code -- Sunpower TPO Release 1.5 -- 28/06/2014         
       String  countryDomain =  System.Label.CountryDomain_FR; 
        if (countryDomain.contains(user.Country_Domain__c))
            validateCountryFrance = true;

        return validateCountryFrance;
    }//End Func validateCountry

    //Called when "Save" button is clicked on the EditResidentialAccount VF Page
    public PageReference save() 
    {
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();        
        Pagereference retPage = null; 

        if(partnerUser.Contact.Account.Name == 'SunPower New Homes' && baseUrl != null && baseUrl.contains('sunpower1.visual.force.com')){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'You are not supposed to create New Homes Customer Account from the Community'));
            return null;
        }
        setRecordTypes();
        
        if(validateCountry())
            validateDepartment();
        else
            validate();

        if(Apexpages.hasMessages(Apexpages.Severity.ERROR)) {
            return retPage;
        }
        
        if(isEdit == 'N')  
        {
            Savepoint sp = Database.setSavepoint();
            try 
            {           
                newCustomer= createCustomer();                       //Create customer          
                contact=     createContact(newCustomer);             //Create contact           
                newOpp=      createOpportunity(newCustomer, contact);//Create opportunity
            } 
            catch(System.DmlException ex){
                for(integer i = 0; i< ex.getNumDml(); i++) {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, ex.getDmlMessage(i)));

                }
 
                Database.rollback(sp);
                return retPage;
            } 
            catch(Exception ex){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Following error occurred while creating opportunity:  ' + ex.getMessage()));
                
                Database.rollback(sp);
                return retPage;
            }

            if(recTypeId == residentialCustomerRecordTypeId)  //This means THIS IS COMING FROM ACCOUNT TAB, HENCE NEEDS TO GO BACK TO ACCOUNT VIEW PAGE
                retPage= new pageReference('/'+ newCustomer.id);
            else if(recTypeId == commercialCustomerRecordTypeId || recTypeId == commercialRecordTypeId || recTypeId == residentialRecordTypeId)             //This means THIS IS COMING FROM OPPORTUNITY TAB, HENCE NEEDS TO GO BACK TO OPPORTUNITY VIEW PAGE 
                retPage= new pageReference('/'+ newOpp.id);

            retPage.setRedirect(true);                
        }
        else if(isEdit == 'Y')  
        {
            updateDetails(opp,newCustomer,contact);
            retPage= new pageReference('/'+ newCustomer.id);
            retPage.setRedirect(true);
        }

        normalRedirectUrl = retPage.getUrl();
        
        if(isResidentialPage())
            return null;
        else
            return retPage;
    }//End Func save        
    
    //Called when "Save and Quote" button is clicked on the EditResidentialAccount VF Page
    public PageReference saveAndQuote() 
    {
        businessRegParameter = null;
        Pagereference retPage = null;
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        if(partnerUser.Contact.Account.Name == 'SunPower New Homes'  && baseUrl != null && baseUrl.contains('sunpower1.visual.force.com')){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'You are not supposed to create New Homes Customer Account from the Community'));
            return null;
        }

        if(validateCountry())
        {    
            setRecordTypes();
            validateDepartment();

            if(Apexpages.hasMessages(Apexpages.Severity.ERROR)){ return retPage; }

            if(isEdit == 'N')  
            {
                Savepoint sp = Database.setSavepoint();
                try 
                {
                    newCustomer = createCustomer();                    ////Create customer
                    contact = createContact(newCustomer);              ////Create contact
                    newOpp = createOpportunity(newCustomer, contact);  ////Create opportunity                    
                } 
                catch(System.DmlException ex){
                    for(Integer i = 0; i< ex.getNumDml(); i++) {
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, ex.getDmlMessage(i)));

                    }
                    Database.rollback(sp);
                    return retPage;
                } 
                catch(Exception ex) {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Following error occurred while creating opportunity:  ' + ex.getMessage()));
                    Database.rollback(sp);
                    return retPage;
                }
            }

            if(newCustomer.InvalidDepartment__c == true && partnerUser.Quote_Creation_Allowed__c == true)
                retPage = new PageReference('/apex/TPO_RoofDetailstab?aid='+newCustomer.Id+'&oppId='+newOpp.Id);
            else
                retPage = new pageReference('/'+ newCustomer.id);          

            retPage.setRedirect(true);
            return retPage;         
        }
        else
        {
            validate();
            if(Apexpages.hasMessages(Apexpages.Severity.ERROR))
                return retPage; 
                       
            save();
            if(newcustomer.billingcountry == Label.Australia)
                retPage = new PageReference('/apex/GPPNewQuoteButton?acc='+newCustomer.Id+'&opp='+newOpp.Id);
            else{
                 if(newCustomer.Id != null){
                    Account acc = [select Business_Registration__c,Business_Registration__r.Is_License_Valid__c from Account where Id = :newCustomer.Id];
                    if(acc.Business_Registration__c != null && acc.Business_Registration__r.Is_License_Valid__c)
                       retPage = new PageReference('/apex/Quickquote?aid='+newCustomer.Id+'&oppId='+newOpp.Id);
                    else
                       businessRegParameter = 'License doesnt exist or expired';   
                       
                }
            }
            if(retPage != null)                
            retPage.setRedirect(true);
            return retPage;
        } 
        return retPage;
    }//End Func saveAndQuote

    //Called when "Cancel" button is clicked on the EditResidentialAccount VF Page
    public PageReference cancel() 
    {
        PageReference pg = null;
        
        if(isEdit == 'Y')
            pg = new PageReference('/' + newCustomer.Id);
        else if(recTypeId == commercialCustomerRecordTypeId || recTypeId == residentialCustomerRecordTypeId) //This means THIS IS COMING FROM ACCOUNT TAB, HENCE NEEDS TO GO BACK TO ACCOUNT VIEW PAGE
            pg = new PageReference('/001/o');
        else if(recTypeId == commercialRecordTypeId || recTypeId == residentialRecordTypeId)                 //This means THIS IS COMING FROM OPPORTUNITY TAB, HENCE NEEDS TO GO BACK TO OPPORTUNITY VIEW PAGE 
            pg = new PageReference('/006/o');
            
        pg.setRedirect(true);
        return pg;
    }//End Func cancel
    
    //Utility function to create Customer Account
    private Account createCustomer() {
        newCustomer.Status__c = 'Active';

        if (recType == COMMERCIAL) {
            newCustomer.Type= COMMERCIAL;
            newCustomer.RecordTypeId= commercialCustomerRecordTypeId;
        } else {
            newCustomer.Type= HOME_OWNER;
            newCustomer.RecordTypeId= residentialCustomerRecordTypeId;
            newCustomer.Geo__Latitude__s= latitude;
            newCustomer.Geo__Longitude__s= longitude; 
        }
        
        newCustomer.Theater__c= opp.Theater__c;
        newCustomer.Partner_Portal_Registration__c= true;
        
        updateCustomerDetails(opp, newCustomer);
        
        //Name is set directly via UI, default is opty name, but user can choose a name other than opty name
        if(isResidentialPage())
            newCustomer.Name= contact.FirstName + ' ' + contact.LastName;

        //Added by Ujjal - Pivotal # 131678969 - Remove special characters and multiple spaces 
        String sCusNameWoutSplCh = newCustomer.Name.replaceAll('[^a-zA-Z0-9]', ' ');

        String sCusNameWoutSplChandMulSpace = sCusNameWoutSplCh.replaceAll('\\s+',' '); 
        newCustomer.Name = sCusNameWoutSplChandMulSpace;
        //Added by Ujjal - Pivotal # 131678969 - End

        insert newCustomer; 
        return newCustomer;
    }//End Func createCustomer

    //Utility function to create Customer Contact
    @TestVisible
    private Contact createContact(Account newCustomer) 
    {
        contact.AccountId = newCustomer.id;
        contact.Partner_Portal_Registration__c= true;
        contact.Primary__c= true;
        
        contact.Preferred_Language_Code__c = prefLangSelected;  //Added for Pivotal ## 130538551

        updateContactDetails(opp,newCustomer);
        
        insert contact;
        return contact;
    }//End Func createContact

    //Utility function to create Customer Opportunity
    @TestVisible   
    private Opportunity createOpportunity(Account newCustomer, Contact contact) 
    {
        // Instead of setting values from opp , we can use clone method as well..do it later, in case the create screen also needs to be
        // updated similar to edit screen with all the fields 
        // Opportunity newOpp = opp.clone(true,false);

        Opportunity newOpp= new Opportunity(AccountId = newCustomer.id,
                                            Name= newCustomer.Name,
                                            OwnerId= partnerUser.Id,
                                            Partner_Account_Id__c= opp.Partner_Account_Id__c,
                                            Opportunity_Status__c= 'Active',
                                            CloseDate= opp.CloseDate,
                                            Theater__c = (opp.Theater__c != null ? opp.Theater__c : partnerAccount.Theater__c),
                                            Lead_Manufacturer__c= opp.Lead_Manufacturer__c,
                                            Installation_Date__c = opp.Installation_Date__c,
                                            Contract_Type__c = opp.Contract_Type__c,
                                            Commercial_Operation_Date__c = opp.Commercial_Operation_Date__c,
                                            Primary_Contact__c= contact.id,
                                            RecordTypeId= opp.RecordTypeId,
                                            CurrencyIsoCode= partnerAccount.CurrencyIsoCode,
                                            StageName= opp.StageName,
                                            Country__c= newCustomer.BillingCountry,
                                            Amount= opp.Amount,
                                            Partner_Portal_Registration__c= true,
                                            Best_Time_To_Call__c= opp.Best_Time_To_Call__c,
                                            Lease__c= opp.Lease__c);
                          
        if(recType == HOME_OWNER){
            newOpp.Business_Unit__c= opp.Business_Unit__c;
            newOpp.RLC_Type__c= opp.RLC_Type__c;
            newOpp.Lead_Referral_Name__c= opp.Lead_Referral_Name__c;
            newOpp.Sub_Region__c= opp.Sub_Region__c;
        }
        else if(recType == COMMERCIAL){
            newOpp.System_Size_KwP__c= opp.System_Size_KwP__c;
            newOpp.Project_Stage__c= opp.Project_Stage__c;
            newOpp.Location_of_Installation__c= opp.Location_of_Installation__c;
            newOpp.Mounting_System__c= opp.Mounting_System__c;
            newOpp.PV_Type__c= opp.PV_Type__c;
            newOpp.Invertor__c= opp.Invertor__c;
            if(!isEUProfile)
                newOpp.ARRA_Compliance__c =opp.ARRA_Compliance__c;

            newOpp.Count_of_Sites__c= opp.Count_of_Sites__c; 
            
            newOpp.Facility_State1__c= newCustomer.Facility_State__c;
            newOpp.Facility_City1__c= newCustomer.Facility_City__c;
            newOpp.Facility_Address1__c= newCustomer.Facility_Address__c;
            newOpp.Facility_Zip1__c= newCustomer.Facility_Zip__c;
            newOpp.Projected_Delivery_Date__c= opp.CloseDate;
            newOpp.Delivery_Date__c = opp.CloseDate;
            newOpp.Opportunity_Status__c = 'Qualified';
            newOpp.RLC_Type__c = 'Light Commercial';
            newOpp.Business_Unit__c = 'RLC';
            newOpp.CRSM__c = partnerUser.Contact.Account.CRSM__c;
        }
        
        //insert newOpp; #129544575
        String oppResultId = '';
        Database.SaveResult result = Database.insert(newOpp);
        if(result.isSuccess())
            oppResultId = result.getId();
        

        //Added: Shree Prashant: 28 mar 2013: Loan Path Enhancement    
        if(recType == HOME_OWNER){
            OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.IsPrimary= true;
                ocr.ContactId= contact.Id;
                ocr.OpportunityId= newOpp.Id;
                ocr.Role= 'Borrower';
            insert ocr;
        }
        else if(recType == COMMERCIAL) { //#129544575
            Site_Information_Form__c site = new Site_Information_Form__c();    
                site.Account__c= newCustomer.Id;
                site.RecordTypeId= siteRecordTypeId;
                site.Site_Status__c= 'Active';
                site.Site_Name__c = newOpp.Name;
                site.Opportunity_del__c = oppResultId;
                site.Site_Address__c = newOpp.Facility_Address1__c;
                site.Site_State__c = newOpp.Facility_State1__c;
                site.Site_City__c = newOpp.Facility_City1__c;
                site.Site_Zip_Postal_Code__c = newOpp.Facility_Zip1__c;
                site.Site_Country__c = newOpp.Country__c == null ? newCustomer.BillingCountry : newOpp.Country__c;
            insert site;
        }
    
        return newOpp;
    }//End Func createOpportunity

    //Utility for Customer/Account fields population
    private void updateCustomerDetails(Opportunity opp, Account newCustomer) 
    {
        newCustomer.Name= opp.Name;
        newCustomer.ShippingCountry= newCustomer.BillingCountry;
        if(newCustomer.BillingCountry == Label.Australia)
            newcustomer.Sales_Tax_Rate__c = Decimal.valueof(Label.Sales_Tax_Rate_Australia);
            
        newCustomer.ShippingCity= newCustomer.BillingCity;
        newCustomer.ShippingStreet= newCustomer.BillingStreet;
        newCustomer.ShippingState= newCustomer.BillingState;
        newCustomer.ShippingPostalCode= newCustomer.BillingPostalCode;
        
        for(Vertex_Address_Validation__c objAddress : [SELECT id, geo_county__c,Geo_City__c 
                                                          FROM Vertex_Address_Validation__c 
                                                          WHERE geo_postal_code__c =: newCustomer.BillingPostalCode]){
                    if(objAddress.Geo_City__c == newCustomer.ShippingCity 
                        && !String.isEmpty(objAddress.geo_county__c)
                        && newCustomer.BillingCountry.contains(Label.United_States)) 
                        newCustomer.Oracle_County__c= objAddress.geo_county__c; 
            
        } 
        /*
        if(!countyList.isEmpty() 
            && String.isNotBlank(countyList[0].geo_county__c) 
                && newCustomer.BillingCountry == Label.United_States)
            newCustomer.Oracle_County__c= countyList[0].geo_county__c;    */
                
        newCustomer.Oracle_Shipping_County__c= newCustomer.Oracle_County__c;
        newCustomer.Contact_Language__c= contact.Contact_Language__c;
        
        //Populate facility address fields if record type is commercial
        if(recType == COMMERCIAL){
            newCustomer.Facility_City__c= newCustomer.BillingCity;
            newCustomer.Facility_Address__c= newCustomer.BillingStreet;
            newCustomer.Facility_State__c= newCustomer.BillingState;
            newCustomer.Facility_Zip__c= newCustomer.BillingPostalCode;
        }
                 
        if(recType == HOME_OWNER && (!isEUProfile) && newCustomer.Lease__c == true){
            newCustomer.Oracle_Customer_Classification__c = O_CUSTOMER_CLASSIFICATION;
            newCustomer.Oracle_Warehouse__c = partnerAccount.Oracle_Warehouse__c;
            newCustomer.Oracle_Account_Type__c =O_ACCOUNT_TYPE;
            newCustomer.Oracle_Sales_Channel__c = O_SALES_CHANNEL;
            newCustomer.Oracle_Operating_Unit__c = O_OPERATING_UNIT;
            newCustomer.Oracle_Order_Type__c = O_ORDER_TYPE;
        }    
    }//End Func updateCustomerDetails

    //Utility for Contact fields population
    private void updateContactDetails(Opportunity opp, Account newCustomer) 
    {
        if(!isResidentialPage())
            contact.LastName= newCustomer.Name;
            
        contact.Phone= newCustomer.phone;  
        contact.Fax= newCustomer.phone;  
        contact.Email= newCustomer.Email__c;
        contact.MailingState= newCustomer.BillingState;
        contact.MailingCountry= newCustomer.BillingCountry;
        contact.MailingCity= newCustomer.BillingCity;
        contact.MailingStreet= newCustomer.BillingStreet;
        contact.MailingPostalCode= newCustomer.BillingPostalCode;
        contact.Contact_Language__c= newCustomer.Contact_Language__c;
    }//End Func updateContactDetails
    
    //Utility for Opportunity fields population
    private void updateOppDetails(Account newCustomer) 
    {
        opp.Facility_State1__c= newCustomer.Facility_State__c;
        opp.Facility_City1__c= newCustomer.Facility_City__c;
        opp.Facility_Address1__c= newCustomer.Facility_Address__c;
        opp.Facility_Zip1__c= newCustomer.Facility_Zip__c;
        opp.Facility_Address_2__c= newCustomer.Facility_Address_2__c;
    }//End Func updateOppDetails

    //Fetach all details realted to Customer/Account, Contact, Opportunity
    public void populateOppAccountAndContactDetails(String accId)
    {
        if(newCustomer == null )
            newCustomer= new Account();
    
        List<Account> newCustomerList = [SELECT id, Name , RecordTypeId, RecordType.Name, 
                                                isPersonAccount, Phone, Theater__c, Email__c, 
                                                Partner_Portal_Registration__c, Lease__c, Oracle_County__c, Contact_Language__c,
                                                Facility_State__c, Facility_City__c, Facility_Address__c, Facility_Address_2__c, Facility_Zip__c, 
                                                BillingCountry, BillingCity, BillingStreet, BillingState, BillingPostalCode,
                                                ShippingCountry, ShippingCity, ShippingStreet, ShippingState, ShippingPostalCode                                                
                                         FROM Account 
                                         WHERE Id =: accId AND 
                                               Partner_Portal_Registration__c= true];
        
        if(!newCustomerList.isEmpty())
            newCustomer= newCustomerList[0];
        
        if(opp == null)
            opp= new Opportunity();

        String name = '%' + newCustomer.Name + '%';
        
        List<Opportunity> oppList = [SELECT id, AccountId, Name, OwnerId, Owner.Name, StageName, RecordTypeId, RecordType.Name, 
                                            Probability ,Amount, Reason_Won_Lost__c, Reason_Won_Lost_comments__c, CloseDate,IsClosed, IsWon, Installation_Date__c, 
                                            //How_did_you_hear_about_us__c, KCM_06082016: this field has been replaced with field below.
                                            hear_about_us__c, //KCM_06082016: replacement field added.
                                            How_long_have_you_owned_your_home__c,
                                            Commercial_Operation_Date__c,
                                            Contract_Type__c,
                                            Motivation_for_Solar__c, Unshaded_Roof__c, Already_Receiving_Quotes__c, Roof_Orientation__c,
                                            Request_Dealer_Quote__c, Average_Monthly_Electricity_Bill__c, Lead_Manufacturer__c, 
                                            Best_Time_To_Call__c, Campaign.Name, CampaignId,
                                            Description,LeadSource, Lead_Referral_Name__c, Lead_Web_Form_Details__c, Alliance_Program_Lead__c,
                                            Referral_Program_Status__c, Roof_Material__c, System_Size__c, 
                                            Quote__c, Quote_Details__c, Package__c, Down_Payment__c, Roof_sq_ft__c, Monthly_Cost__c,Net_Cost__c,
                                            Monthly_Savings__c, Total_Savings__c, Quality_Inspection_opt_in__c, Customer_Satisfaction_survey_opt_in__c, Marketing_opt_in__c,
                                            Warranty_Signed_Italy__c, Internal_Comments__c, Opportunity_Number_SYS__c, Opportunity_type__c, 
                                            CurrencyIsoCode, Partner_Account_Id__c, Project_Stage__c, 
                                            Opportunity_Status__c, Country__c, Sub_Region__c, Business_Unit__c,RLC_Type__c, Theater__c, Count_of_Sites__c,
                                            Account.Name, Account.Phone, Account.Facility_State__c, Account.Facility_City__c, Account.Facility_Address__c, Account.Facility_Zip__c,
                                            Primary_Contact__c, Primary_Contact__r.Id, Primary_Contact__r.AccountId, Primary_Contact__r.LastName, Primary_Contact__r.Phone, Primary_Contact__r.Email,
                                            Aging__c, PO_Receipt_Date__c, Commercial_Project_num__c, Deposit_received__c,
                                            Facility_Address1__c, Facility_Address_2__c, Facility_City1__c, Facility_State1__c, Facility_Zip1__c,
                                            Projected_Delivery_Date__c, System_Size_KwP__c, ARRA_Compliance__c,Warranty__c,
                                            Financing_Status__c, Financing_in_Place_date__c, Financing_in_Place__c, Financing_Options_Provided_date__c, Financing_Application_Submitted__c, 
                                            Rebate_Confirmed__c, Location_of_Installation__c,Invertor__c, Quantity_1__c, Mounting_System__c, Mounting_system1__c,
                                            Inverter_2__c, Inverter_3__c, Quantity_3__c, PV_Type__c, Quantity_2__c, EPA_Requested__c, EPA_Generated__c,
                                            Ground_or_Roof_Space__c, Roof_Height__c, Roof_Slope__c, Zone_Monitoring__c, Utility_Voltage__c,
                                            Number_of_Sites_to_Install_Solar__c, Grounding__c, Site_Audit_Review_Status__c,Revision__c, Site_Audit_Form_Received__c, 
                                            Site_Audit_Complete__c, Inspection_Date__c, Final_Inspection_Schedule_Date__c, Inspection_Report_Sent__c, Final_Insp_Report_Sent__c,
                                            Opportunity_CreatedDate__c, Opportunity_LastModifiedDate__c, LastModifiedBy.Name, Financing__c, Customer_Funding_Type__c
                                    FROM Opportunity 
                                    WHERE accountId =: newCustomer.Id AND 
                                          Partner_Portal_Registration__c= true];
        
        if(!oppList.isEmpty())
            opp= oppList[0];            
        
        List<Contact> contactList = [SELECT id, AccountId, RecordTypeId, RecordType.Name, 
                                            FirstName, LastName, Name, Phone, Email, Contact_Language__c, 
                                            MailingState, MailingCountry, MailingCity, MailingStreet, MailingPostalCode                                              
                                     FROM Contact 
                                     WHERE id =: opp.Primary_Contact__c AND 
                                           Partner_Portal_Registration__c= true];
            
        if(!contactList.isEmpty())
            contact= contactList[0];
    }//End Func populateOppAccountAndContactDetails 
    
    public void updateDetails(Opportunity opp, Account newCustomer, Contact contact) 
    {
        if(newCustomer != null){
            updateCustomerDetails(opp,newCustomer);
            update newCustomer;
        }
        
        if(contact != null){
            updateContactDetails(opp,newCustomer);
            update contact;
        }
        
        if(opp != null){
            updateOppDetails(newCustomer);
            update opp; 
        }      
    }//End Func updateDetails   
    
    //Utility function
    public Boolean isResidentialPage() 
    {
        return System.currentPageReference().getUrl().toLowerCase().contains('residentialaccount');
    }//End Func isResidentialPage

    //Utility function
    private void validate() 
    {
        if(opp.CloseDate < Date.today())
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Close Date cannot be less than today\'s date.'));

        if(!validatedAddress)
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'The address information needs to be completed.'));
        AddressValidation.isValid(newCustomer.BillingStreet);
    }//End Func validate

    //Utility function
    private void validateDepartment() 
    {
        if(System.Label.InvalidDepartments.contains(newCustomer.Oracle_County__c))
            newCustomer.InvalidDepartment__c= true ;
    }//End Func validateDepartment

    
    @RemoteAction
    public static List<Vertex_Address_Validation__c> checkAddressInformation( String zip ) 
    {    
        List<Vertex_Address_Validation__c> addressValidations = [SELECT Id, Geo_Postal_Code__c, Geo_State__c, 
                                                                        Geo_City__c, Geo_County__c 
                                                                 FROM Vertex_Address_Validation__c
                                                                 WHERE Geo_Postal_Code__c=: zip 
                                                                 ORDER BY Geo_City__c LIMIT 10];
        return addressValidations;
    }//ENd Func checkAddressInformation 
    
/******** FUNCTION : end ********/

}//End Class AccountExtension
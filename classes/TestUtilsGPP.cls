/********************************************************************************************
Author : Birlasoft
Usage  : Test Utility Class for GPP Related Development
Edits  :    

********************************************************************************************/

@isTest
public class TestUtilsGPP 
{
/****** VARIABLE: start ******/
    public static final string RECORDTYPE_ACCOUNT_PARTNER;
    public static final string RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER;
    public static final string RECORDTYPE_CONTACT_CUSTOMER;
    public static final string RECORDTYPE_OPPORTUNITY_HOME_OWNER;
    public static final string RECORDTYPE_QUOTE_PROPOSAL_QUOTE;
    
    public static final Profile PROFILE_PARTNER;
    
    public static Account CreatedPartnerAccount;
    public static Account CreatedInstallerAccount1;
    public static Account CreatedInstallerAccount2;
    public static Contact CreatedPartnerContact;
    
/******* VARIABLE: end *******/

/****** STATIC: start ******/   
    static{
        for(RecordType rc: [SELECT id, name, sObjectType, developername 
                            FROM RecordType 
                            WHERE IsActive = true AND 
                                  sObjectType IN ('Account', 'Contact', 'Opportunity','Quote') AND 
                                  DeveloperName IN ('Partner', 'Residential_Customer', 'Customer', 'Home_Owner', 'AU_Proposal_Quote')])
        {
            if(rc.sObjectType=='Account' && rc.developerName=='Partner')
                RECORDTYPE_ACCOUNT_PARTNER= rc.Id;      
            //if(rc.sObjectType=='Account' && rc.developerName=='Residential_Customer')
            if(rc.sObjectType=='Account' && rc.developerName=='Home_Owner')
                RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER= rc.Id;
            if(rc.sObjectType=='Contact' && rc.developerName=='Customer')
                RECORDTYPE_CONTACT_CUSTOMER= rc.Id;
            if(rc.sObjectType=='Opportunity' && rc.developerName=='Home_Owner')
                RECORDTYPE_OPPORTUNITY_HOME_OWNER= rc.Id;
            if(rc.sObjectType=='Quote' && rc.developerName=='AU_Proposal_Quote')
                RECORDTYPE_QUOTE_PROPOSAL_QUOTE= rc.Id;
        }
        
        PROFILE_PARTNER= [SELECT Id FROM Profile WHERE Name= 'AU Partner Executive'];
        
    }//End static
/******* STATIC: end *******/

/****** FUNCTION: start ******/

    public static Account createAccount(String name, String recordTypeId, Boolean willInsert )
    {
        Account acct = new Account(name= name, 
                                   recordTypeID= recordTypeId);

            acct.ShippingCity = 'Northcote';
            acct.ShippingStreet = '159 Heidelberg Rd';
            acct.ShippingCountry = 'Australia';
            acct.ShippingState='VIC';
            acct.ShippingPostalCode ='3070';
            acct.BillingCity = 'Northcote';
            acct.BillingStreet = '159 Heidelberg Rd';
            acct.BillingCountry = 'Australia';
            acct.BillingState='VIC';
            acct.BillingPostalCode ='3070';
            acct.Online_Order_Access__c = true;
            acct.Oracle_Account_Number__c = 'BWGUY'+String.ValueOf(DateTime.Now().getTime())+Math.random();
            acct.Phone = (String.ValueOf(DateTime.Now().getTime())).substring(0, 10);

        if(willInsert)
            insert acct;
        return acct;
    }//End Func createAccount
    
    public static Account createAccountUS(String name, String recordTypeId, Boolean willInsert )
    {
        Account acct = new Account(name= name, 
                                   recordTypeID= recordTypeId);
            acct.ShippingCity = 'Carlsbad';
            acct.ShippingStreet = '6965 EL CAMINO REAL, STE. 105-444';
            acct.ShippingCountry = 'United States';
            acct.ShippingState='CA';
            acct.ShippingPostalCode ='92009';
            acct.BillingCity = 'Carlsbad';
            acct.BillingStreet = '6965 EL CAMINO REAL, STE. 105-444';
            acct.BillingCountry = 'United States';
            acct.BillingState='CA';
            acct.BillingPostalCode ='92009';
            acct.Online_Order_Access__c = true;
            acct.Oracle_Account_Number__c = 'BWGUY'+String.ValueOf(DateTime.Now().getTime())+Math.random();
            acct.Phone = (String.ValueOf(DateTime.Now().getTime())).substring(0, 10);

        if(willInsert)
            insert acct;
        return acct;
    }//End Func createAccount
    
    public static Account createAccountFR(String name, String recordTypeId, Boolean willInsert )
    {
        Account acct = new Account(name= name, 
                                   recordTypeID= recordTypeId);
                                
            acct.ShippingCity = 'Riorges';
            acct.ShippingStreet = '1431, Rue Louise Michel4';
            acct.ShippingCountry = 'France';
            acct.ShippingState='France';
            acct.ShippingPostalCode ='42153';
            acct.BillingCity = 'Riorges';
            acct.BillingStreet = '1431, Rue Louise Michel4';
            acct.BillingCountry = 'France';
            acct.BillingState='France';
            acct.BillingPostalCode ='42153';
            acct.Online_Order_Access__c = true;
            acct.Oracle_Account_Number__c = 'BWGUY'+String.ValueOf(DateTime.Now().getTime())+Math.random();
            acct.Phone = (String.ValueOf(DateTime.Now().getTime())).substring(0, 10);

        if(willInsert)
            insert acct;
        return acct;
    }//End Func createAccount
    
    
    
    public static Account createInstallerAccount(String name, String recordTypeId, Boolean willInsert )
    {
        Account instAccount = new Account(name= name, 
                                   recordTypeID= recordTypeId);

            instAccount.ShippingCity = 'Northcote';
            instAccount.ShippingStreet = '159 Heidelberg Rd';
            instAccount.ShippingCountry = 'Australia';
            instAccount.ShippingState='VIC';
            instAccount.ShippingPostalCode ='3070';
            instAccount.BillingCity = 'Northcote';
            instAccount.BillingStreet = '159 Heidelberg Rd';
            instAccount.BillingCountry = 'Australia';
            instAccount.BillingState='VIC';
            instAccount.BillingPostalCode ='3070';
            instAccount.Online_Order_Access__c = true;
            instAccount.Oracle_Account_Number__c = 'BWGUY'+String.ValueOf(DateTime.Now().getTime())+Math.random();
            instAccount.Phone = (String.ValueOf(DateTime.Now().getTime())).substring(0, 10);
            instAccount.Lease2_0_Program_Partner__c= true;
            instAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
            instAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
            instAccount.Oracle_Warehouse__c  = 'WAR'+String.ValueOf(DateTime.Now().getTime()).substring(0, 5);
            instAccount.Oracle_County__c='Australia';   
            instAccount.Oracle_Shipping_County__c='Australia';
            instAccount.Specialized_Installer__c='Service Stream';
            instAccount.Certified__c=true;
            instAccount.Theater__c='Australia';
            instAccount.Type='Residential Installer';
            instAccount.NH_SSE_Type__c='Install';
    
        if(willInsert)
            insert instAccount;
        return instAccount;
    }//End Func createInstallerAccount
    public static Partner associateInstallerWithSeller(Account seller, Account installer, String partnerRole, Boolean willInsert)
    {
        Partner sellerInstaller=new Partner(AccountFromId=seller.Id,AccountToId=installer.Id, Role=partnerRole);
        if(willInsert)
            insert sellerInstaller;
        return sellerInstaller;           
    }
    public static Contact createContact(String name, Id accountId, Boolean willInsert)
    {
        String sUnique= String.valueOf(DateTime.now().getTime());
        
        Contact cont = new Contact(accountID= accountId, 
                                   firstName=name, 
                                   lastName= sUnique);
        
            cont.Email = 'au.' + sUnique + '@test.com.test';
            cont.Phone = '999-888-6677';
            cont.MailingCity = 'Northcote';
            cont.MailingStreet = '159 Heidelberg Rd';
            cont.MailingCountry = 'Australia';
            cont.MailingState='VIC';
            cont.MailingPostalCode ='3070';
            cont.Authorized_to_Order__c = true;

        if(willInsert)
            insert cont;
        return cont;
    }//End Func createContact
    
    public static List<Contact> createCustomerContacts(Integer numConts, String name, Id accountId, String sRecordTypeId, Boolean willInsert)
    {
        List<Contact> lstCCOnts= new List<Contact>();
        for(Integer i=0; i<= numConts; i++){
            String sUnique= String.valueOf(DateTime.now().getTime());
            Contact cont = new Contact(accountID= accountId, 
                                       firstName=name, 
                                       lastName= sUnique,
                                       recordTypeId= sRecordTypeId);
            
                cont.Email = name+ '.' + sUnique + '@test.com.test';
                cont.Phone = '991-888-6677';
                cont.MailingCity = 'Northcote';
                cont.MailingStreet = '160 Heidelberg Rd';
                cont.MailingCountry = 'Australia';
                cont.MailingState='VIC';
                cont.MailingPostalCode ='3071';
                cont.Include_in_Lease_Doc__c= true;
                if(i==0){
                    cont.Primary__c= true;
                    cont.Role__c= 'Technical Buyer';
                    cont.Authorized_to_Order__c= true;
                }
                cont.Override_Duplicate_Check__c=true;
            lstCCOnts.add(cont);
        }
        if(willInsert)
            insert lstCCOnts;
            
        return lstCCOnts;
    }//End Func createContact
    
    public static List<Contact> createCustomerUSContacts(Integer numConts, String name, Id accountId, String sRecordTypeId, Boolean willInsert)
    {
        List<Contact> lstCCOnts= new List<Contact>();
        for(Integer i=0; i<= numConts; i++){
            String sUnique= String.valueOf(DateTime.now().getTime());
            Contact cont = new Contact(accountID= accountId, 
                                       firstName=name, 
                                       lastName= sUnique,
                                       recordTypeId= sRecordTypeId);

                cont.Email = name+ '.' + sUnique + '@test.com.test';
                cont.Phone = '991-888-6677';
                cont.MailingCity = 'Carlsbad';
                cont.MailingStreet = '6965 EL CAMINO REAL, STE. 105-444';
                cont.MailingCountry = 'United States';
                cont.MailingState ='CA';
                cont.MailingPostalCode ='92009';
                cont.Include_in_Lease_Doc__c= true;
                if(i==0){
                    cont.Primary__c= true;
                    cont.Role__c= 'Technical Buyer';
                    cont.Authorized_to_Order__c= true;
                }
                cont.Override_Duplicate_Check__c=true;
            lstCCOnts.add(cont);
        }
        if(willInsert)
            insert lstCCOnts;
            
        return lstCCOnts;
    }//End Func createContact   
   
    public static List<Contact> createCustomerFRContacts(Integer numConts, String name, Id accountId, String sRecordTypeId, Boolean willInsert)
    {
        List<Contact> lstCCOnts= new List<Contact>();
        for(Integer i=0; i<= numConts; i++){
            String sUnique= String.valueOf(DateTime.now().getTime());
            Contact cont = new Contact(accountID= accountId, 
                                       firstName=name, 
                                       lastName= sUnique,
                                       recordTypeId= sRecordTypeId);
  
                cont.Email = name+ '.' + sUnique + '@test.com.test';
                cont.Phone = '991-888-6677';
                cont.MailingCity = 'Riorges';
                cont.MailingStreet = '1431, Rue Louise Michel';
                cont.MailingCountry = 'France';
                cont.MailingState ='France ';
                cont.MailingPostalCode ='42153';
                cont.Include_in_Lease_Doc__c= true;
                if(i==0){
                    cont.Primary__c= true;
                    cont.Role__c= 'Technical Buyer';
                    cont.Authorized_to_Order__c= true;
                }
                cont.Override_Duplicate_Check__c=true;
            lstCCOnts.add(cont);
        }
        if(willInsert)
            insert lstCCOnts;
            
        return lstCCOnts;
    }//End Func createContact   

    public static User createPartnerPortalUser(Contact cont, Boolean willInsert)
    {
        String sUnique= String.valueOf(DateTime.now().getTime());
        
        User user = new User(lastName = 'BSL'+ sUnique ,
                             firstName = 'AU'+ sUnique.subString(sUnique.length()-7, sUnique.length()));
            user.ContactId = cont.Id;
            String username ='au' + sUnique + '.aup@auprog.com.test';
            user.Username = username;
            user.CommunityNickname = username.subString(0,7);
            user.Alias = 'qWT';
            user.Phone = '1800786769';
            
            user.TimeZoneSidKey = 'Australia/Sydney';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_AU';
            user.DefaultCurrencyIsoCode= 'AUD';
            user.CurrencyIsoCode= 'AUD';
            user.ProfileId = PROFILE_PARTNER.Id;
        if(willInsert)
            insert user;
        return user;
    }//End Func createPartnerPortalUser

    public static List<Opportunity> createCustomerOpportunities(Integer numOfOpp, Id accountId, Id contactId, String sRecordTypeId, Boolean willInsert)
    {

        List<Opportunity> lstOpp= new List<Opportunity>();

        for(Integer i = 0; i < numOfOpp; i++ ){
            String sUnique= String.valueOf(DateTime.now().getTime());
            lstOpp.add(new Opportunity(RecordTypeId= sRecordTypeId,
                                        Name = 'AUOpp' + sUnique + String.valueof(i),
                                        StageName = '100% Qualified Opportunity',
                                        CloseDate = Date.today().addDays(2),
                                        OwnerId = UserInfo.getUserId(),
                                        Amount= 100,
                                        AccountId= accountId,
                                        Primary_Contact__c= contactId,
                                        Reason_Won_Lost__c = 'Best Economics',
                                        //System_Size_KwP__c = 100;
                                        //Location_of_Installation__c = 'Metal Roof',
                                        //Mounting_System__c = 'PV Only',
                                        //ARRA_Compliance__c = 'Non ARRA',
                                        Lead_Manufacturer__c= 'Partner',
                                        Business_Unit__c= 'RLC',
                                        RLC_Type__c= 'Residential'));
        }

        if(willInsert)
            insert lstOpp;
            
        return lstOpp;
    }//End Func createOpportunities
    
    public static User createPartnerInfoAU(){
        UserManagement.IS_TEST= true;
        
        List<Account> lstAcc= new List<Account>();
            //// Lease enabled Partner Account Creation
            Account partnerAccount = TestUtils.createAccount('TEST_AU_PARTNER', TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false);
                partnerAccount.Lease2_0_Program_Partner__c= true;
                partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
                partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
                partnerAccount.Oracle_Warehouse__c  = 'WAR'+String.ValueOf(DateTime.Now().getTime()).substring(0, 5);
            lstAcc.add(partnerAccount);
            
            ////Installer
            lstAcc.add(TestUtilsGPP.createInstallerAccount('TEST_AU_INST1' + String.ValueOf(Math.random()).replace('.','').substring(0,10), TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false));
            lstAcc.add(TestUtilsGPP.createInstallerAccount('TEST_AU_INST2' + String.ValueOf(Math.random()).replace('.','').substring(0,10), TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false));
            
        insert lstAcc;
            CreatedPartnerAccount= lstAcc[0];
            
        
        List<Partner> lstPartner= new List<Partner>();
        
            lstPartner.add(TestUtilsGPP.associateInstallerWithSeller(lstAcc[0], lstAcc[1], 'Installer', false));
            lstPartner.add(TestUtilsGPP.associateInstallerWithSeller(lstAcc[0], lstAcc[2], 'Installer', false));
        
        insert lstPartner;
            CreatedInstallerAccount1= lstAcc[1];
            CreatedInstallerAccount2= lstAcc[2];
            
        //// Partner Contact Creation
        Contact partnerContact = TestUtilsGPP.createContact('BSLAU', partnerAccount.Id, true);
            CreatedPartnerContact= partnerContact;
            
        //// Partner User Creation
        User partnerUser= TestUtilsGPP.createPartnerPortalUser(partnerContact, false);
        return partnerUser;
    }//End Func createPartnerInfoAU

    Public static List<Quote> createCustomerQuotes(Integer noOfQuotes,Account acc,Opportunity opp,Contact cont,String recTypeId, String installerId, Boolean willInsert)
    {
        List<Quote> lstQuotes=new List<Quote>();
        for(Integer i=0;i<noOfQuotes;i++)
        {
        Quote newQuote = new Quote( Name='GppQuoteTest'+i);
        newQuote.ContactID=Cont.ID; 
        newQuote.OpportunityId = opp.ID;
        //newQuote.AccountID=acc.id;
        newQuote.Account__c=acc.id;
        newQuote.RecordTypeID=recTypeId;
        newQuote.QuoteType__c = 'Lease';                
        newQuote.Description__c = 'GppQuoteTest'+i;
        newQuote.Installer__c= installerId;     
        newQuote.Quote_type__c= 'Residential Lease Quotation'; 
        lstQuotes.add(newQuote); 
        }

        if(willInsert)
            insert lstQuotes;
    
        return lstQuotes;
    } //End Func createCustomerQuotes
    
    //Case 00754398:
    Public static List<Quote> createNHQuotes(Integer noOfQuotes,Account acc,Opportunity opp,Contact cont,String recTypeId, String installerId, Boolean willInsert)
    {
        List<Quote> lstQuotes=new List<Quote>();
        for(Integer i=0;i<noOfQuotes;i++)
        {
        Quote newQuote = new Quote( Name='GppQuoteTest_NewHomes'+i);
        newQuote.ContactID=Cont.ID; 
        newQuote.OpportunityId = opp.ID;
        //newQuote.AccountID=acc.id;
        newQuote.Account__c=acc.id;
        newQuote.RecordTypeID=recTypeId;
        newQuote.QuoteType__c = 'Lease';                
        newQuote.Description__c = 'GppQuoteTest_NewHomes'+i;
        newQuote.Installer__c= installerId;     
        newQuote.Quote_type__c= 'Residential New Homes Lease Quotation'; 
        lstQuotes.add(newQuote); 
        }

        if(willInsert)
            insert lstQuotes;
    
        return lstQuotes;
    } //Case 00754398: end
    
    //Case 00754398:
    Public static List<Quote> createTPSQuotes(Integer noOfQuotes,Account acc,Opportunity opp,Contact cont,String recTypeId, String installerId, Boolean willInsert)
    {
        List<Quote> lstQuotes=new List<Quote>();
        for(Integer i=0;i<noOfQuotes;i++)
        {
        Quote newQuote = new Quote( Name='GppQuoteTest_TPS'+i);
        newQuote.ContactID=Cont.ID; 
        newQuote.OpportunityId = opp.ID;
        newQuote.Account__c=acc.id;
        newQuote.RecordTypeID=recTypeId;
        newQuote.QuoteType__c = 'Lease';                
        newQuote.Description__c = 'GppQuoteTest_TPS Quote'+i;
        newQuote.Quote_type__c= 'TPS Quote'; 
        lstQuotes.add(newQuote); 
        }

        if(willInsert)
            insert lstQuotes;
    
        return lstQuotes;
    } //Case 00754398: end
    
Public static List<Quote_Line__c> createQuoteLines(Integer noOfQuoteLines,Quote newQuote, Boolean willInsert)
{
 String ITEM_ID_FAKE = '1234123123123x';
//create Item
        Item__c newItem = new Item__c(Item_ID__c = ITEM_ID_FAKE,Product_Type__c= 'testtype');
        insert newItem;
//Create Price List
        Price_List__c priceList = new Price_List__c();
        priceList.Name='TPO FR Pricelist';
        priceList.CurrencyIsoCode='EUR';
        priceList.DSR_PO_Group_Email__c = 'commande@sunpowercorp.com';
        insert priceList;
        
        //Create Price list Item
        Price_List_Item__c newpricelistitem = new Price_List_Item__c();
        newpricelistitem.Name='SPR E20 327';
        newpricelistitem.Item_ID__c = newItem.id;
        newpricelistitem.CurrencyIsoCode='EUR';
        newPricelistitem.Price_List__c = priceList.id;
        newpricelistitem.Manufacturing_cost__c = 0.0; 
        newPricelistitem.Category__c = 'Module';
        insert newpricelistitem;
        
        List<Quote_Line__c> lstQLs = new List<Quote_Line__c>();
        for(Integer i=0;i<noOfQuoteLines;i++)
        {
        Quote_Line__c newQL1 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 1',Quantity__c = 1);
        lstQLs.add(newQL1);
        }
        if(willInsert)
            insert lstQLs;
        return lstQLs;      
}     //End of createQuoteLines Method  
/******* FUNCTION: end *******/ 
    
}//End Class TestUtilsGPP
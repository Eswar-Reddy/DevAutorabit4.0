/* This test class for POWizardPaginationHelper */

@isTest 
private class TestPOWizardPaginationHelper {
    
    
        //Function to get Partner Account
        private static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;
             
        Account acct = new Account(name='test'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test-12345';
        acct.BillingCity = 'san mateo';
          acct.BillingStreet = 'Concar drive';
          acct.BillingPostalCode ='94402';
          acct.BillingCountry = 'USA'; 
        insert acct;
        //setDealerShippingSite(acct);
        //setDealerBillingSite(acct);
        return acct;                     
    }
    
        private static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Executive' or Profile.Name = 'EU Partner Executive' ) and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and isActive = true LIMIT 1]){
            user =u;
        }
        if(user != null) return user;
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        insert cont;        
        String username ='testconbyPO2@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';     
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Executive'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u; 
        return user;
        
    }
    
    //Function to create Opportunity
     private static Opportunity createOpp(Account acct,User u){
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.ID;
        //opp.PartnerAccountId = acct.ID;
        opp.Name = 'testOpp';
        opp.StageName = 'Closed Won';
        opp.Opportunity_Status__c = 'Closed Won';
        opp.Type = 'Residential';
        opp.ownerId = u.Id;
        opp.CloseDate = System.today();
        opp.Probability = 10 ; 
        opp.Reason_Won_Lost__c = 'Best Economics';
        insert opp;
        return opp;
    }


    public static testMethod void TestPOWizardPaginationHelperFunction1(){
            Account acct = getPartnerAccount();
            User u =getPartnerPortalUser(acct);
            acct = u.Contact.Account;
            System.runAs(u){
                List<Opportunity> oppList = new List<Opportunity>();
                 Opportunity opp = createOpp(acct,u);
                 oppList.add(opp);
                 ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(opp);
                 POWizardPaginationHelper pgHelper = new POWizardPaginationHelper();
                 //pgHelper.oppList = oppList;
                 pgHelper.getOppCount(acct.Id);
                 pgHelper.getOpportunityList();
                 pgHelper.getOppList(acct.Id,false,2,2);
                 pgHelper.moveFirst();
                 pgHelper.moveNext();
                 pgHelper.moveLast();
                 pgHelper.movePrevious();
                 pgHelper.getOpportunityList();
                 pgHelper.getOppListSearched(acct.Id,'Invalid',false,2,2);
                 
            }
        }
        
        /*public static testMethod void TestPOWizardPaginationHelperFunction2(){
            Account acct = getPartnerAccount();
            User u =getPartnerPortalUser(acct);
            acct = u.Contact.Account;
            System.runAs(u){
                List<Opportunity> oppList = new List<Opportunity>();
                 Opportunity opp = createOpp(acct,u);
                 oppList.add(opp);
                 ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(opp);
                 POWizardPaginationHelper pgHelper = new POWizardPaginationHelper();
                 //pgHelper.oppList = oppList;
                 pgHelper.getOppCount(acct.Id); 
                 pgHelper.getOppList(acct.Id,true,2,2);
                 pgHelper.moveFirst();
                 pgHelper.moveNext();
                 pgHelper.moveLast();
                 pgHelper.movePrevious();
                 pgHelper.getOpportunityList();
                 pgHelper.getOppListSearched(acct.Id,'test',true,2,2); 
                 
            }
        }*/
}
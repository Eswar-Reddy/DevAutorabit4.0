public class Test_Assign_Opportunity{

@isTest
    public static void testAssignOpportunity(){
        Opportunity opp = new Opportunity (name='opptest',StageName='10% - Qualified Opportunity',CloseDate = Date.Today().addDays(2));
        insert opp;
        Account acc = new Account(Name='A'+String.valueOf(DateTime.Now()));
        acc.BillingCity = 'san mateo';
        acc.BillingStreet = 'Concar drive'; 
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA';
        insert acc;
        Account_Geography__c accGeo = new Account_Geography__c(Account__c=acc.id,Postal_Code__c='1234');
        insert accGeo;    
        Contact c = new Contact(FirstName='fst123',Lastname='lst123',AccountID=acc.id);    
        insert c;
        Profile p = [Select id from profile where name='Partner Delegated Administrator'];
        user u = new User();
        u.firstName = 'u111';
        u.LastName ='l111';
        if(c.firstName.length()>8)
          u.alias=c.firstName.substring(0,8).trim();
        else
          u.alias = c.firstName;
        u.Email = 'a123@a123.com';
        u.UserName='a123@a123.com';
        u.ProfileId = p.id;
        u.CommunityNickname = u.firstname+'_'+u.lastName;
        u.EmailEncodingKey ='ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey ='America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.contactId=c.id;      
        u.isActive = true;
      
        Test.startTest();
        //insert u;
        
        ApexPages.StandardController oppCtrl = new ApexPAges.StandardController(opp);
        Assign_Opportunity_Controller control = new Assign_Opportunity_Controller(oppCtrl);
        control.onPageLoad();
        control.cancel();
        control.proceed();
        
        opp.AccountID = acc.id;
        //update opp; 
        ApexPages.StandardController oppCtrl1 = new ApexPAges.StandardController(opp);
        Assign_Opportunity_Controller control1 = new Assign_Opportunity_Controller(oppCtrl1);
        control1.onPageLoad();                
        control1.proceed();
        
        acc.BillingPostalCode = '1234';
        update acc;
        ApexPages.StandardController oppCtrl2 = new ApexPAges.StandardController(opp);
        Assign_Opportunity_Controller control2 = new Assign_Opportunity_Controller(oppCtrl2);
        control2.onPageLoad();        
        control2.proceed();
        
        Test.stopTest();
    }

}
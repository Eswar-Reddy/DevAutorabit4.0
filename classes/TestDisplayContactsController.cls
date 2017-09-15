/**************************************************
** Case - 00011814
**Created By- Kapil Goutam
**Created On- Nov 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test Class for DisplayContactsController
*****************************************************/

@isTest
public class TestDisplayContactsController{


 static testMethod void test_DisplayContactMethod(){
    
    Account acc = new Account(name='testAccount');
    acc.billingCity = 'TestCity';
    acc.BillingCountry = 'TestCountry';
    acc.BillingPostalCode = '12345';
    acc.BillingState = 'TestState';
    acc.BillingStreet = 'TestStreet';
    insert acc;
    
    Contact con = new Contact(LastName='testCon');
    con.accountId = acc.id;
    insert con;
    
    List<Contact> contacts = new List<Contact>();
    
    Date closeDate1 = date.newInstance(2010,10,11);
    Opportunity opp = new Opportunity(name='testOpp',StageName='Closed Won',CloseDate=closeDate1);
    opp.accountId = acc.Id;
    insert opp;

    ApexPages.currentPage().getParameters().put('Id',opp.Id);
    
    DisplayContactsController dcController = new DisplayContactsController();
    ApexPages.StandardController testController = New ApexPages.StandardController(opp);
    dcController = new DisplayContactsController(testController);
    
    Account account = new Account();
    account = dcController.Account;
    
    List<Opportunity> opportunities = [SELECT accountId, 
                                              account.IsPersonAccount, 
                                              account.RecordType.Name, 
                                              account.BillingStreet,
                                              account.BillingPostalCode,
                                              account.BillingCountry,
                                              account.BillingCity,
                                              account.Phone  
                                              FROM Opportunity where Id =:ApexPages.currentPage().getParameters().get('Id') ];
    List<String> accountIds = new List<String>();
    
    if(opp.accountId != null ){
        accountIds.add(opp.accountId);
    }
    
        if(accountIds.size() > 0){
           if(opportunities.size() > 0){
             account = opportunities.get(0).account;
           }else{
               account = new Account();
           } 
       
           dcController.accountRendered = true;
           contacts = dcController.loadContacts(accountIds);
           
           if(contacts != null && contacts.size() > 0){
               dcController.isRecordFound = true;
           }else{
               dcController.labelMessage = System.Label.DisplayContactPartnerAccountMsg;    
           }
        }else{
            dcController.labelMessage = System.Label.DisplayContactPartnerAccountMsg;    
        }
    }
    
    static testMethod void test_DisplayContactMethod2(){

    Account acc = new Account(name='testAccount');
    acc.billingCity = 'TestCityAB';
    acc.BillingCountry = 'TestCountryAB';
    acc.BillingPostalCode = '123452';
    acc.BillingState = 'TestStateAB';
    acc.BillingStreet = 'TestStreetAB';
    insert acc;
    
    Contact con = new Contact(LastName='testConAB');
    con.accountId = acc.id;
    insert con;
    
    List<Contact> contacts = new List<Contact>();
       
    Date closeDate1 = date.newInstance(2010,10,11);
    Opportunity opp = new Opportunity(name='testOpp1',StageName='Closed Won',CloseDate=closeDate1);
    opp.accountId = acc.Id;
    insert opp;
    
    List<String> accountIds = new List<String>();
    
    if(opp.accountId != null){
        accountIds.add(opp.accountId);
    }
    
    ApexPages.currentPage().getParameters().put('Id',opp.Id);
    
    DisplayContactsController dcController = new DisplayContactsController();

    dcController.isPartner = true;
    dcController.accountRendered = false;
    
    Account account = new Account();
    account = dcController.Account;
    
    List<Opportunity> opportunities = [SELECT accountId, 
                                              account.IsPersonAccount, 
                                              account.RecordType.Name, 
                                              account.BillingStreet,
                                              account.BillingPostalCode,
                                              account.BillingCountry,
                                              account.BillingCity,
                                              account.Phone  
                                              FROM Opportunity where Id =: opp.Id ];
    List<String> accountId = new List<String>();
    accountId.add(opp.accountId);
    
        if(accountId.size() > 0){
           if(opportunities.size() > 0){
             account = opportunities.get(0).account;
           }else{
               account = new Account();
           } 
       
           dcController.accountRendered = true;
           contacts = dcController.loadContacts(accountId);
           
           if(contacts != null && contacts.size() > 0){
               dcController.isRecordFound = true;
           }else{
               dcController.labelMessage = System.Label.DisplayContactPartnerAccountMsg;    
           }
        }else{
            dcController.labelMessage = System.Label.DisplayContactPartnerAccountMsg;    
        }
  }
}
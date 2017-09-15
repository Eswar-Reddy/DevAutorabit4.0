/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 30 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for controller PartnerPerformanceDashboardController
Revision History
09.FEB.2012 Anuradha Appirio - Modified test class
01.JUN.2015 MAM - Modified User SOQL to get the correct user record and test class structure 
*****************************************************/
@isTest()
public class TestPartnerPerformanceDashboard{

  public static testmethod void checkPartnerPerformanceDashboardController(){
    
    //R.A. 15.JUNE.2015 - Used the TestUtils class to insert partner user record for testing
    Account partnerAccount = TestUtils.createAccount('TEST PARTNER ACCOUNT 1', TestUtils.getPartnerRecordTypeId(), false);
    Contact partnerContact = TestUtils.createContact( 'TEST PARTNER CONTACT 1', partnerAccount.Id, true );
    partnerContact.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); 
    update partnerContact;
    //create partner user
    User partnerUser = TestUtils.createPartnerPortalUser( partnerContact, false );
    
    List<User> lstUser = new List<User>();
    lstUser = [select Id, Contact.accountId from User where ContactId != null and isActive = true and Profile.Name = 'Partner Executive' Limit 1]; 
    
    User userObj = lstUser[0];
    Id currentAccountId = userObj.Contact.accountId;
    
    List<Opportunity> lstOpps =new List<Opportunity>([Select o.Id From Opportunity o 
      where o.PartnerAccountId =: userObj.Contact.AccountId and o.IsClosed = false and o.IsWon = false]);
    for(Opportunity opp : lstOpps){
        opp.Amount = 0;
    }
    update lstOpps;
    
    System.runAs(userObj){
      List<Opportunity> lstOpp = new List<Opportunity>();
      System.debug('TEST ACCOUNT ID : ' + currentAccountId);
      Opportunity opp1 = new Opportunity();
      opp1.AccountId = currentAccountId;
      opp1.Name = 'TestOpp1';
      opp1.Amount = 0;
      opp1.StageName = 'Qualified Opportunity';      
      opp1.CloseDate = Date.today();     
      opp1.Probability = 10; 
      lstOpp.add(opp1);
      
     
      insert lstOpp;
      PartnerPerformanceDashboardController testObj = new PartnerPerformanceDashboardController();
    }
    
  }
}
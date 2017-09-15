/*************************************************************************
Name       : TestManageOpportunityAccessController
Created By : Appirio Offshore
Date       : 5th Oct 2009
Usage      : Test class for apex class 'ManageOpportunityAccessController'
**************************************************************************/
@IsTest
public class TestManageOpportunityAccessController {
    public static User userRecord;
    public static Account accObj; 
    public static Opportunity oppObj;
    public static List<AggregateResult> partnerAccIdSet= new List<AggregateResult>();
    public static set<ID> partnerAccountIdSet = new Set<ID>();
    
    
    static{
        partnerAccIdSet=[select partneraccountId from opportunity group by PartnerAccountID having count(ID) < 100 and partneraccountId <> null Limit 100];
        
        for (AggregateResult agg :partnerAccIdSet){
        partnerAccountIdSet.add((Id)(agg.get('partneraccountId')));
        }
      //  Id partAccId=(Id)partnerAccIdSet.get('partneraccountId');
       // System.debug('line no 18 Id : '+partAccId);
        List<User> lstUser = [select Id, Name, Contact.Account.Id, Contact.Account.Name 
                          from User
                          where ContactId != null
                          and UserRole.Name like '%Partner Executive' 
                          and isActive = true and Contact.Account.Id IN :partnerAccountIdSet];
        if(lstUser.size() > 0){
          System.debug('line no 25 lstUser.size() : '+lstUser.size());
            userRecord = lstUser[0];
            accObj = new Account(Id = userRecord.Contact.Account.Id, Name = userRecord.Contact.Account.Name);
            System.debug('line no 27 accObj : '+accObj);
            oppObj = New Opportunity();    
            oppObj.AccountId = accObj.Id;     
            oppObj.Name = 'TestOPP';
            oppObj.CloseDate = Date.Today();
            oppObj.StageName = 'New Opportunity'; // RLC Proj-svilla
            Insert oppObj; 
            
        }
        
    }
  @isTest(seeAllData=true) static void test_ManageOpportunityAccessController(){    
    //create test data
    //get user record
    //User userRecord = null;
    /*List<User> lstUser = [select Id, Name, Contact.Account.Id, Contact.Account.Name 
                          from User
                          where ContactId != null
                          and UserRole.Name like '%Partner Executive' 
                          and isActive = true Limit 10 ];
    
    if(lstUser.size() > 0){
      userRecord = lstUser[0];
    }
    else{
      return;   
    }*/
    
    //get account
    /*Account accObj = null;    
    accObj = new Account(Id = userRecord.Contact.Account.Id, Name = userRecord.Contact.Account.Name);    
    */
    //create Opportunity and link to account
    /*Opportunity oppObj = New Opportunity();    
    oppObj.AccountId = accObj.Id;     
    oppObj.Name = 'TestOPP';
    oppObj.CloseDate = Date.Today();
    oppObj.StageName = 'New Opportunity'; // RLC Proj-svilla
    Insert oppObj;*/  
    
    //run tests
    Test.startTest();    
    ApexPages.StandardController TestController = New ApexPages.StandardController(accObj);    
    ManageOpportunityAccessController TestConst = new ManageOpportunityAccessController(TestController);        
    TestConst.addSharingRules();
    TestConst.deleteSharingRules();
    TestConst.redirectToAccount();  
    
    
    Test.stopTest();  
  }
  
  @isTest(seeAllData=true) static void test_ManageOpportunityAccessController1(){    
    //create test data
    //get user record
    //User userRecord = null;
    /*List<User> lstUser = [select Id, Name, Contact.Account.Id, Contact.Account.Name 
                          from User
                          where ContactId != null
                          and UserRole.Name like '%Partner Executive' 
                          and isActive = true Limit 10 ];
    */
    /*if(lstUser.size() > 0){
      userRecord = lstUser[0];
    }
    else{
      return;   
    }
    
    //get account
    Account accObj = null;    
    accObj = new Account(Id = userRecord.Contact.Account.Id, Name = userRecord.Contact.Account.Name);    
    Test.startTest();
    //create Opportunity and link to account
    Opportunity oppObj = New Opportunity();    
    oppObj.AccountId = accObj.Id;     
    oppObj.Name = 'TestOPP';
    oppObj.CloseDate = Date.Today();
    oppObj.StageName = 'New Opportunity'; //RLC Proj- Svilla
    Insert oppObj;  */
    
    //run tests
    Test.startTest();    
    ApexPages.StandardController TestController = New ApexPages.StandardController(accObj);    
    ManageOpportunityAccessController TestConst = new ManageOpportunityAccessController(TestController);        
    try
    {
    TestConst.addSharingRules2();
    TestConst.deleteSharingRules2();
    TestConst.redirectToAccount(); 
    } 
    catch(Exception e)
    {
    }
    Test.stopTest();
    
  }
 @isTest(seeAllData=true) static void test_ManageOpportunityAccessController2(){
    //run tests
    Test.startTest();
    ApexPages.StandardController TestController = New ApexPages.StandardController(accObj);    
    ManageOpportunityAccessController2 TestConst2 = new ManageOpportunityAccessController2(TestController);        
    Try
    {
    TestConst2.addSharingRules();
    TestConst2.deleteSharingRules();
    TestConst2.redirectToAccount();
    }
    catch(Exception e)
    {
    }
    Test.stopTest();
    
  }
 
}
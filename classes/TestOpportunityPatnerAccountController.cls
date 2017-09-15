/**************************************************
**Created By- Priyanka Joshi
**Created On- April 06 2012
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller named 'OpportunityPatnerAccountController' 

*****************************************************/
public class TestOpportunityPatnerAccountController {
    @isTest
    public static void Test_OpportunityPatnerAccountController(){
         
         Account acct = TestDataUtility.setUpAccount(null, '', true); 
         Opportunity opp = TestDataUtility.setUpOpportunity(acct.Id, System.today(), true);
         
         Test.startTest();
         OpportunityPatnerAccountController obj = new OpportunityPatnerAccountController();
         obj.oppID = opp.Id;
         Opportunity opp1 = obj.OppObj;
         obj.OppObj = opp;
         
         system.assertEquals(opp.Name, obj.OppObj.Name);
         system.assertEquals(opp.Account.Name, obj.OppObj.Account.Name);
         system.assertEquals(opp.Id, obj.oppID);
         Test.stopTest(); 
        
    } 
}
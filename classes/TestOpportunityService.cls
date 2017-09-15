/**************************************************
**Created By- Harsh Mathur
**Created On- July 22 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for OpportunityService class
*****************************************************/
public class TestOpportunityService{
  
  @isTest
  public static void checkOpportunityService(){
    Opportunity testOpp = new Opportunity();
    testOpp.Name = 'test';
    testOpp.StageName = '25% - Site Audit Completed';
    testOpp.CloseDate = Date.today();
    insert testOpp;
            
    OpportunityService.approveOpportunity(testOpp.Id);
  }
}
public class Refresh_SingleLine_Extension 
{
  Single_Line__c SingleLine;
  Public ID SingleLineid = ApexPages.currentPage().getParameters().get('id');
  
  public Refresh_SingleLine_Extension(ApexPages.StandardController stdController)     
  {        
    this.SingleLine = (Single_Line__c)stdController.getRecord();        
  }
  
  public PageReference Refresh()
  {
    Single_Line__c des = [Select Id, Name,Status__c,Refresh_Count__c FROM Single_Line__c WHERE id =:SingleLineid LIMIT 1];
    Double Rcount = 0;
      Rcount += 1;                               
    if(des.Status__c == 'Active')  
    {
      des.Refresh_Count__c += Rcount;
      //des.Single_Line_Due__c =null;
      des.Single_Line_Tracking__c =null;
      des.Single_Line_Completed__c =null;
      update des;
    }
          
    PageReference SingleLinePage = new ApexPages.StandardController(SingleLine).view();
    SingleLinePage.setRedirect(true);
    return SingleLinePage;
  }
  
}
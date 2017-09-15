public class Refresh_Estimate_Extension 
{
  Estimate__c Estimate;
  public ID Estimateid = ApexPages.currentPage().getParameters().get('id');
  
  public Refresh_Estimate_Extension(ApexPages.StandardController stdController)     
  {        
    this.Estimate = (Estimate__c)stdController.getRecord();        
  }
  
  public PageReference Refresh()
  {
    Estimate__c des = [Select Id, Name,Status__c,Refresh_Count__c FROM Estimate__c WHERE id =:Estimateid LIMIT 1];
    Double Rcount = 0;
      Rcount += 1;                               
    if((des.Status__c != 'Completed') && (des.Status__c != 'Invalid') && (des.Status__c != 'De-Activated')) 
    {
      des.Status__c = 'Not Started';
      des.Refresh_Count__c += Rcount;
      //des.Due_Date__c =null;
      des.Negotiated_Due_Date__c =null;
      des.PM_PPP_Tracking_Date__c =null;
      des.PM_PPP_Review_Tracking_Date__c =null;
      update des;
    }
          
    PageReference EstimatePage = new ApexPages.StandardController(Estimate).view();
    EstimatePage.setRedirect(true);
    return EstimatePage;
  }
  
}
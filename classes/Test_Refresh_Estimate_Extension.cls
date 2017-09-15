Public Class Test_Refresh_Estimate_Extension 
{
@isTest
 public static void testEstimate()
 {
 Test.startTest();
 
 ApexPages.StandardController con6 = new ApexPages.StandardController(new Estimate__c());
 Refresh_Estimate_Extension estimate = new Refresh_Estimate_Extension(con6);
 
 Refresh_Estimate_Extension design3 = new Refresh_Estimate_Extension(con6);
 
 Estimate__c est = new Estimate__c();
 est.Status__c = 'Invalid';
 est.Refresh_Count__c = 2;
 est.Negotiated_Due_Date__c = system.Today();
 est.PM_PPP_Tracking_Date__c = system.Today();
 est.PM_PPP_Review_Tracking_Date__c = system.Today();
 insert est;
 //system.debug('Ashok' + des.id);
 
 estimate.Estimateid = est.id;
 estimate.Refresh();
 
 ApexPages.currentPage().getParameters().put('id', est.id);
 
  Estimate__c design2 = [Select Id, Name,Status__c,Refresh_Count__c FROM Estimate__c WHERE id =:estimate.Estimateid];
 
      Double Rcount = 0;
      Rcount += 1;  
      design2.Status__c = 'Not Started';
      design2.Refresh_Count__c += Rcount;
      design2.Negotiated_Due_Date__c =null;
      design2.PM_PPP_Tracking_Date__c =null;
      design2.PM_PPP_Review_Tracking_Date__c =null;
      update design2 ;
      
    

  estimate.Refresh();
    
 Test.stopTest();
 
 }
 
}
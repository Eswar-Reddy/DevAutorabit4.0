public class Refresh_Design_Extension 
{
  Design__c design;
  public ID designid = ApexPages.currentPage().getParameters().get('id');
  
  public Refresh_Design_Extension(ApexPages.StandardController stdController)     
  {        
    this.design = (Design__c)stdController.getRecord();        
  }
  
  public PageReference Refresh()
  {
    Design__c des = [Select Id, Name,Status__c,Refresh_Count__c FROM Design__c WHERE id =:designid LIMIT 1];
    Double Rcount = 0;
      Rcount += 1;                               
    if((des.Status__c != 'Completed') && (des.Status__c != 'Invalid') && (des.Status__c != 'De-Activated')) 
    {
      des.Status__c = 'Not Started';
      des.Refresh_Count__c += Rcount;
      //des.Due_Date__c =null;
      des.Design_Tracking__c =null;
      des.Date_Design_Completed__c =null;
      des.Date_of_Agreed_Delivery__c =null;
      update des;
    }
          
    
    //return null;
    PageReference designPage = new ApexPages.StandardController(design).view();
    designPage.setRedirect(true);
    return designPage;
  }
  
 /* public ApexPages.StandardSetController con         
  {          
      get {            
      if(con == null)             
      {                
      con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name,Status__c FROM Design__c WHERE id =:designid LIMIT 1]));                                
                  
      }            
      return con;              
       }          
      set;        
  }
  */
}
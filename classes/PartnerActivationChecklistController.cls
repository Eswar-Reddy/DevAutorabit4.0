/***********************************************
***Created By- Kapil Goutam
***Created On- May 30 2009 
***Last Modified By - 
***Last Modified On- 
***Description- Controller class for PartnerActivationChecklist & EU_PartnerActivationChecklist Pages
***********************************************/
public class PartnerActivationChecklistController{     
  public Account acc{get;set;}
  public String accId{get;set;} 
  
  public PartnerActivationChecklistController(ApexPages.StandardController stdController){    
    if(ApexPages.currentPage().getParameters().get('id') != null){
      accId = ApexPages.currentPage().getParameters().get('id');
      List<Account> listAccount = new List<Account>();
      listAccount = [Select Id, Welcome_Kit_Ordered__c, Territory_Assigned__c, 
        SunPower_University_Access__c, SmartStore_Access__c, 
        Signed_and_Notarized_Personal_Guaranty__c, Signed_Premier_Partner_Agreement__c, 
        Signed_Non_Disclosure_Agreement__c, Signed_Authorized_Partner_Agreement__c, 
        Resale_Certificate__c, Partner_Portal_Access__c, Completed_and_Signed_Credit_Application__c, 
        Sent_Partner_Package__c, Oracle_Account_Created__c, Forecasting_Tool_Access__c, 
        Welcome_Communication_Customer_Team__c From Account where Id = :accId];
      
      if(listAccount.Size() > 0){
        acc = listAccount.get(0);        
      }   
    }       
  }
  
  public PageReference quickSaveChecklist(){
    if(this.acc != null){
      update this.acc;      
    }
    return null;
  }
  
  public PageReference saveChecklist(){
    if(this.acc != null){
      update this.acc;
      PageReference returnPage = new PageReference('/' + acc.Id);
      return returnPage;      
    }
    return null;
  }  
}
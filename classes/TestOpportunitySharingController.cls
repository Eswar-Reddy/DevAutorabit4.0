public class TestOpportunitySharingController{
    @isTest 
    public static void checkShareOpportunities(){    
        //create test data
        //get user record
        User userRecord = null;
        List<User> lstUser = new List<User>();
        lstUser = [select Id, Name, Contact.Account.Id, Contact.Account.Name 
                          from User
                          where ContactId != null
                          and Profile.Name like '%Partner Delegated%' 
                          and UserRole.Name like '%Partner User' 
                          and isActive = true 
                          and Contact.Account.Allow_all_to_view_Opportunities__c = true
                          and ByPassValidation__c = true
                          Limit 1];
    
        if(lstUser.size() > 0){
          userRecord = lstUser[0];
        }
        else{
          return;   
        }
        
        //get account
        Account accObj = null;    
        accObj = new Account(Id = userRecord.Contact.Account.Id, Name = userRecord.Contact.Account.Name,Allow_all_to_view_Opportunities__c=true);            
        
        //create Opportunity and link to account
        Opportunity oppObj = New Opportunity();    
        oppObj.AccountId = accObj.Id;     
        oppObj.Name = 'TestOPP';
        oppObj.CloseDate = Date.Today();
        oppObj.StageName = '10% - Qualified Opportunity';
        oppObj.Probability = 10;
        Insert oppObj;  
        oppObj.OwnerId = userRecord.id;
        update oppObj;
        
        //run tests                          
        System.runAs(userRecord){
            //accObj.Allow_all_to_view_Opportunities__c=true;
            //update accObj;
            Account accObj1 = new Account(Name = 'TestAccount');     
            accObj1.BillingCity = 'san mateo';
      accObj1.BillingStreet = 'Concar drive';
      accObj1.BillingPostalCode ='94402';
      accObj1.BillingCountry = 'USA';      
            insert accObj1;     
            OpportunitySharingController.shareOpportunities(accObj1.ID);              
        }        
  }
}
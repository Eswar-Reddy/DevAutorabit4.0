/********************************************************************************************
Name   : CreditApplicationTabController
Author : Aashish Mathur
Date   : May 04, 2010
Usage  : Controller of VF page CreditApplicationTab which is used to list CA to the portal
         user related to his Account.
         
Case#00149047 - Amit Saha ,3 new country domains:combo-rl,rvar-rl,cvar-rl @Line 61
Case#00180237 -Bharti , added two condition for new credit application.

********************************************************************************************/

public class CreditApplicationTabController {
    public List<Credit_Application__c> creAppList {get; private set;}
    public String retURL {get; private set;}
    private PageReference standardTab;
    private String CA_KeyPrefix;
    private User currentUser;
    //for case #00045173
    public boolean isEuPartnerUser{get;set;}
    //for case #00045173
    
    // Done for Case # 00069900
    public Boolean displayCA{get;set;}
    
    public CreditApplicationTabController() {
        retURL = EncodingUtil.urlEncode(ApexPages.currentPage().getUrl(), 'UTF-8');
        CA_KeyPrefix = Credit_Application__c.SObjectType.getDescribe().getKeyPrefix();
        standardTab = null;
        //for case #00045173
        isEuPartnerUser = false;
        //currentUser = [SELECT UserType, Contact.AccountId, Contact.Account.Name FROM User WHERE Id =:UserInfo.getUserId()];
        // Done for Case # 00069900
        displayCA = true;
        //currentUser = [SELECT Profile.Name, UserType, Contact.AccountId, Contact.Account.Name FROM User WHERE Id =:UserInfo.getUserId()];
        currentUser = [SELECT Profile.Name,ContactId,UserType, Contact.AccountId, Contact.Account.Name ,Contact.Account.BillingCountry,Contact.Country_Domain__c FROM User WHERE Id =:UserInfo.getUserId()];
        System.debug('****'+currentUser); 
        
        //for case #00045173
        if (currentUser.UserType == 'PowerPartner') {
            ID accountId = currentUser.Contact.AccountId;             

            creAppList = [SELECT Id, Name, Legal_Company_Name__c, Account__c, Credit_Limit_Requested__c, Credit_Limit__c,//for case # 00045173
                    Date_of_Application__c, Status__c FROM Credit_Application__c
                    WHERE Account__c =:accountId ORDER BY Name];
                  
            if(currentUser.Profile.Name.startsWith('EU') && currentUser.ContactId != null)
            {
                 isEuPartnerUser = true;
                // Done for Case # 00069900
                                if(currentUser.ContactId != null && currentUser.Contact.Country_Domain__c!= null
                    && !currentUser.Contact.Country_Domain__c.contains('it')
                    && !currentUser.Contact.Country_Domain__c.contains('de')
                    && !currentUser.Contact.Country_Domain__c.contains('es')
                    //Added for case#00149047
                    && !currentUser.Contact.Country_Domain__c.contains('rl')
                    //Start--->Done for case#00180237
                    && !currentUser.Contact.Country_Domain__c.contains('fr')
                    && !currentUser.Contact.Country_Domain__c.contains('be')
                    //Finish--->Done for case#00180237


                    )
                {
                 System.debug('Enter Else');

                        displayCA = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.NoSuffecientAccess));
                }
            }
            
        } else {
            creAppList = new List<Credit_Application__c>();
            standardTab = new PageReference('/' + CA_KeyPrefix + '/o?nooverride=1');
        }
    }
    
    public PageReference redirectInternalUser() {
        return standardTab;
    }
    
    public PageReference newCreApp() {        
        //for case # 00045173  
          
        //Start 00119907                
        String companyName = currentUser.Contact.Account.Name;
        if(currentUser.Contact.Account.Name != null)
            companyName = currentUser.Contact.Account.Name.replace('&', '%26');
        //End 00119907
            
        PageReference pg = new PageReference('/' + CA_KeyPrefix + '/e?retURL=' + retURL+'&CF00N80000003bRUi='+companyName );        
        pg.setRedirect(true);        
        return pg;
        //for case # 00045173
    }
}
/********************************************************************************************
Name   : AccountNewController 
Author : Anjali Jain
Date   : Oct 17, 2011
Usage  : Controller of VF page AccountNew that performs following actions depending on the user profile
        1. If user is partner user, then redirect them to a custom page that creates the account,opportunity and 
        contact 
        2. else Redirect other users to standard new page.
/*** Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013, to re direct FR Partner user to New Account creation VF page
********************************************************************************************/

public class AccountNewController 
{
/****** VARIABLE : start ******/

    public String newUrl {get; set;}
    //private static Id commercialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
    //private static Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId(); 
    
    private static Id commercialCustomerRecordTypeId; 
    private static Id residentialCustomerRecordTypeId;
    public static User partnerUser {get;set;}  //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
    public String UserType { get{ return UserInfo.getUserType(); } }
    
/******* VARIABLE : end *******/  

/****** PROPERTY : start ******/
/******* PROPERTY : end *******/  

/****** STATIC BLOCK : start ******/
    
    static
    {//New Code -- Sunpower TPO Phase 1 -- 20/10/2013
        partnerUser = [select UserType, Profile.Name, 
                              IsPortalEnabled, Country, Country_Domain__c
                       from User 
                       where ID = :Userinfo.getUserId()];
        //Validate the 3 fields on the partner account record, oracle vendor id, site id, lease2.0 program partner
    }//End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
    
/******* STATICK BLOCK : end *******/ 

/****** CONSTRUCTOR : start ******/

    public AccountNewController(ApexPages.StandardController controller) 
    {
        newUrl = ApexPages.currentPage().getURL();
        setRecordTypes();
    }
    
/******* CONSTRUCTOR : end *******/  

/****** FUNCTION : start ******/

    private void setRecordTypes() 
    {
        List<RecordType> recordTypeList = [Select Id, Name  
                                           From RecordType  
                                           where Name IN ('Commercial Customer','Residential Customer') and sobjectType = 'Account' ];

        for(RecordType recType : recordTypeList )
        {
            if(recType.Name == 'Commercial Customer')    
                commercialCustomerRecordTypeId=recType.Id;
            else if(recType.Name == 'Residential Customer') 
                residentialCustomerRecordTypeId=recType.Id;             
        }
    }//End Func setRecordTypes

    public PageReference redirect() 
    {
        PageReference pg;
        Id recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        String  countryDomain =  System.Label.CountryDomain_FR;  
        
       // if(partnerUser.Country_Domain__c != countryDomain )
       If (!(countryDomain.contains(partnerUser.Country_Domain__c)))
        {
            if('PowerPartner'.equals(UserType)) 
            {
                if(partnerUser.Country_Domain__c.toLowerCase().endsWith('au'))//If AU partner is creating the Customer
                {
                    newUrl = newUrl.replace('/apex/AccountNew?','/apex/EditResidentialAccount?');
                    newUrl = newUrl.replace('&save_new=1&sfdc.override=1', '&nooverride=1');
                    newUrl += '&ent=Account&RecordType=' + residentialCustomerRecordTypeId;               
                }
                else
                {
                    if(commercialCustomerRecordTypeId != null &&  commercialCustomerRecordTypeId == recTypeId)                  
                        newUrl = newUrl.replace('/apex/AccountNew?','/apex/EditCommercialAccount?');
                    else if(residentialCustomerRecordTypeId != null &&  residentialCustomerRecordTypeId == recTypeId) 
                        newUrl = newUrl.replace('/apex/AccountNew?','/apex/EditResidentialAccount?');
   
                    newUrl = newUrl.replace('sfdc.override','nooverride');
                    newUrl = newUrl.replace('&save_new=1','');               
                }
                pg = new PageReference(newUrl);                 
            }           
            else 
            {
                newUrl = newUrl.replace('/apex/AccountNew?','/001/e?');
                newUrl = newUrl.replace('sfdc.override','nooverride');
                newUrl = newUrl.replace('&save_new=1','');
                pg = new PageReference(newUrl);          
                pg.setRedirect(true);   
            }         
         }
         else
         {
            if('PowerPartner'.equals(UserType)) 
            {
                newUrl = newUrl.replace('/apex/AccountNew?','/apex/tpo_editresidentialaccount?');
                newUrl = newUrl.replace('sfdc.override','nooverride');
                newUrl = newUrl.replace('&save_new=1','');
                pg = new PageReference(newUrl);            
            }            
            else 
            {
                newUrl = newUrl.replace('/apex/AccountNew?','/001/e?');
                newUrl = newUrl.replace('sfdc.override','nooverride');
                newUrl = newUrl.replace('&save_new=1','');
                pg = new PageReference(newUrl);          
                pg.setRedirect(true);   
            }         
         }     
         return pg;
    }//End Func redirect    
/******* FUNCTION : end *******/  

/****** WRAPPER : start ******/
/******* WRAPPER : end *******/     
       
}//End Class AccountNewController
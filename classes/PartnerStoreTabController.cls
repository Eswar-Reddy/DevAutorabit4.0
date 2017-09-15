/************************************************************************************
Name    : PartnerStoreTabController
Date    : Mar 09, 2010
Author  : Aashish Mathur
Purpose : Controller class of VF page PartnerStoreTab which is used to check if
          current user has access to "Partner Store" tab.
Revision History:
20.NOV.2014 - MAM - update string to get value from the Custom Setting case 00423392
************************************************************************************/

public class PartnerStoreTabController {
    public final User currentUser {get; private set;}
    public final String BASE_URL {get; private set;}
    public final String redirectURL {get; private set;}//for Case# 00089278
    
    public PartnerStoreTabController() {
        currentUser = [SELECT Partner_Store_Visible__c, Profile.Name, Country_Domain__c
                FROM User WHERE Id = :UserInfo.getUserId()];
        
        redirectURL = ApexPages.CurrentPage().getParameters().get('redirectURL');//for Case# 00089278
        //MAM 20.NOV.2014 - update string to get value from the Custom Setting start
        if (SalesforceOrgUtils.isPRoductionOrg() == true) {
            //Tertiary operator to ensure that the Base URL has a value even if the Custom Setting was not setup
            BASE_URL = String.IsNotEmpty(Java_Server_Settings__c.getInstance('Java Servers').PORTAL_PROD_URL__c)? Java_Server_Settings__c.getInstance('Java Servers').PORTAL_PROD_URL__c : 'https://www.sunpowersupport.com';
            //BASE_URL = 'https://www.sunpowersupport.com';
        } else {
            //Tertiary operator to ensure that the Base URL has a value even if the Custom Setting was not setup
            BASE_URL = String.IsNotEmpty(Java_Server_Settings__c.getInstance('Java Servers').PORTAL_QA_URL__c)? Java_Server_Settings__c.getInstance('Java Servers').PORTAL_QA_URL__c : 'https://uat.sunpowersupport.com';
            //BASE_URL = 'https://uat.sunpowersupport.com';
        }
        //MAM 20.NOV.2014 - update string to get value from the Custom Setting end
    }
}
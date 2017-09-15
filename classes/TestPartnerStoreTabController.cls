/************************************************************************************
Name    : TestPartnerStoreTabController
Date    : Mar 09, 2010
Author  : Aashish Mathur
Purpose : Test class of apex class PartnerStoreTabController.
Revision History:
20.NOV.2014 - MAM - update string to get value from the Custom Setting case 00423392
************************************************************************************/

@isTest
private class TestPartnerStoreTabController {
    @isTest
    public static void testController() {
        PartnerStoreTabController controller = new PartnerStoreTabController();
        //MAM 20.NOV.2014 - update string to get value from the Custom Setting start
        //Tertiary operator to ensure that the Base URL has a value even if the Custom Setting was not setup
        String PORTAL_QA_URL =  String.IsNotEmpty(Java_Server_Settings__c.getInstance('Java Servers').PORTAL_QA_URL__c)? Java_Server_Settings__c.getInstance('Java Servers').PORTAL_QA_URL__c : 'https://uat.sunpowersupport.com';
        String PORTAL_PROD_URL = String.IsNotEmpty(Java_Server_Settings__c.getInstance('Java Servers').PORTAL_PROD_URL__c)? Java_Server_Settings__c.getInstance('Java Servers').PORTAL_PROD_URL__c : 'https://www.sunpowersupport.com';
    
        if (SalesforceOrgUtils.isPRoductionOrg() == true) {
            System.assertEquals(controller.BASE_URL, PORTAL_PROD_URL);
        } else {
            System.assertEquals(controller.BASE_URL, PORTAL_QA_URL);
        }
        //MAM 20.NOV.2014 - update string to get value from the Custom Setting end
    }
}
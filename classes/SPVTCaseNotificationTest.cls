@isTest
public class SPVTCaseNotificationTest {

    private static testMethod void test_noContactRole() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_noContactRole();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.SendEmailResponse response = SPVTCaseNotification.sendEmail(qualifyMap);
        system.assertEquals(0, response.emailList.size());
    }

    private static testMethod void test_contactRole() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_contactRole();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.SendEmailResponse response = SPVTCaseNotification.sendEmail(qualifyMap);
        system.assertEquals(1, response.emailList.size());
    }

    private static testMethod void test_additionalEmails() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_additionalEmails();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.SendEmailResponse response = SPVTCaseNotification.sendEmail(qualifyMap);
        system.assertEquals(1, response.emailList.size());
        system.assertEquals(2, response.emailList[0].getCcAddresses().size());
    }

    private static testMethod void test_orgWideEmailAddress() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_orgWideEmailAddress();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.SendEmailResponse response = SPVTCaseNotification.sendEmail(qualifyMap);
        system.assertEquals(1, response.emailList.size());
        system.assertNotEquals(null, response.emailList[0].getOrgWideEmailAddressId());
    }

    private static testMethod void test_SPD_contactRole() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_SPD_contactRole();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.SendEmailResponse response = SPVTCaseNotification.sendEmail(qualifyMap);
        system.assertEquals(0, response.emailList.size());
    }

    private static testMethod void test_nonSPD_inactive_contactRole() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_nonSPD_inactive_contactRole();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.SendEmailResponse response = SPVTCaseNotification.sendEmail(qualifyMap);
        system.assertEquals(0, response.emailList.size());
    }

    private static testMethod void test_NotificationFlag_NonSPD() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_NotificationFlag_NonSPD();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.setDealerInstallerNotification(qualifyMap);
        system.assertEquals(false, td.case_1.Dealer_Installer_Notification__c = false);
    }

    private static testMethod void test_NotificationFlag_SPD() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_NotificationFlag_SPD();
        
        Map <Integer, Case> qualifyMap = new Map <Integer, Case>();
        qualifyMap.put(1, td.case_1); 
        SPVTCaseNotification.setDealerInstallerNotification(qualifyMap);
        system.assertEquals(true, td.case_1.Dealer_Installer_Notification__c = true);
    }

    private static testMethod void test_caseTrigger() {
        SPVTCaseNotificationTestData td = new SPVTCaseNotificationTestData();
        td.createTestData_caseTrigger();
    }
    
}
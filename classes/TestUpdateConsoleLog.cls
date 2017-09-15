@isTest
private class TestUpdateConsoleLog {
    static testMethod void unitTest1() {
    
    UserRole role = [SELECT Id FROM UserRole WHERE Name='Customer Services Representative'];
    Profile profile = [SELECT Id FROM Profile WHERE Name='xxx SunPower Service User'];
    User u2 = new User(
        Alias = 'newUser1', 
        Email='newuser001@testorg.com', 
        EmailEncodingKey='UTF-8', 
        LastName='Testing', 
        LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', 
        ProfileId = profile.Id,
        UserRoleId = role.Id,
        TimeZoneSidKey='America/Los_Angeles', 
        UserName='newuser001@testorg.com'
    );
    
        System.runAs(u2) {
            
            Service_Console_Links_Section__c consoleSection = new Service_Console_Links_Section__c();
            consoleSection.Name = 'CSR_1';
            consoleSection.Role__c = '00E800000010ZVw';
            consoleSection.Section_Name__c = 'CSR Links';
            insert consoleSection;
            
            Service_Console_Links_URL__c consoleUrl = new Service_Console_Links_URL__c();
            consoleUrl.Name = 'CSR_101_GoToInfoLease';
            consoleUrl.Label__c = 'Go To Info Lease';
            consoleUrl.Section_Name__c = 'CSR Links';
            consoleUrl.Title__c = 'Go To Info Lease';
            consoleUrl.URL__c = 'https://sunpowerbillpaycsr.osgview.com/';
            insert consoleUrl;
        
            PageReference updateInfoLeasePage = Page.InfoLease;
            Test.setCurrentPage(updateInfoLeasePage);
              
            UpdateConsoleLog uconsole=new UpdateConsoleLog();
            
            uconsole.InsertIntoConsoleLog();
            uconsole.UpdateTimeInAppTracker();
        }
    }
  
}
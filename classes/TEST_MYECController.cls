@isTest
public class TEST_MYECController {
    
    public static TestMethod void testEnergyConsultantController() {
        
        User ecUser = TestClassFactory.testUser('Solar Advisor', 'emailName' + String.valueOf(date.today()).subString(0,6) + '@spddev.test', 'spdtst');
        ecUser.Division = 'Test';
        ecUser.Country = 'United States';
        ecuser.About__c = 'This is an about me section';
        insert ecUser;
        System.assert(ecUser.Id != null);
        
        Opportunity_Design__c fakeECImage = new Opportunity_Design__c();
        fakeEcImage.User__c = ecUser.Id;
        fakeEcImage.Design_Photo__c = 'this is a fake image of an energy consultant';
        insert fakeEcImage;
        System.assert(fakeEcImage.Id != null);

        ApexPages.currentPage().getParameters().put('id', ecUser.Id);
        MYECController controller = new MYECController();
        
     	PageReference pageRef = Page.MeetYourConsultant;
        Test.setCurrentPage(pageRef);        
        
    }
    
    public static TestMethod void negTestEnergyConsultantController() {

        ApexPages.currentPage().getParameters().put('id', TestClassFactory.getFakeId(Lead.SObjectType));
        MYECController controller = new MYECController();
        
     	PageReference pageRef = Page.MeetYourConsultant;
        Test.setCurrentPage(pageRef);        
        
    }

}
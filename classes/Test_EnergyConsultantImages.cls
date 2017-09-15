@isTest
public class Test_EnergyConsultantImages {
    
    static TestMethod void testECImage() {
        
        User energyConsultant = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        energyConsultant.Country = 'USA';
        energyConsultant.Division = 'Test';
        energyConsultant.SOX_Profile_was_approval_received__c = true;
        insert energyConsultant;
        
        Opportunity_Design__c od = new Opportunity_Design__c();
        od.Design_Photo__c = 'This is a design Image!';
        od.User__c = energyConsultant.id;
        insert od;
        
        Test.startTest();
        
        PageReference ref = Page.MeetYourConsultant;
        Test.setCurrentPage(ref);
        ApexPages.currentPage().getParameters().put('id', energyConsultant.Id);
            
        MYECController controller = new MYECController();
        controller.ownerName = String.valueOf(energyConsultant.Id);
        
        
        Test.stopTest();
        
       
    }
    
    static TestMethod void testNOImage() {
        
        Test.startTest();
        
        PageReference ref = Page.MeetYourConsultant;
        Test.setCurrentPage(ref);
        ApexPages.currentPage().getParameters().put('id', TestClassFactory.getFakeId(User.sObjectType));
            
        MYECController controller = new MYECController();
        
        Test.stopTest();
        
    }

}
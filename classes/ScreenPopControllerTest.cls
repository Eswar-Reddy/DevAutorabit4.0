@isTest
public class ScreenPopControllerTest {

    private static testMethod void test_oneAccount() {
        ScreenPopControllerTestData td = new ScreenPopControllerTestData();
        td.createTestData_oneAccount();
    
        Test.setFixedSearchResults(new List <Id>{td.account_1.Id});
        PageReference pr = Page.ScreenPop;
        pr.getParameters().put('ANI', '1112223333');
        Test.setCurrentPage(pr);
        ScreenPopController controller = new ScreenPopController();
        
        system.assertEquals('1112223333', controller.ani);
        system.assertEquals(td.account_1.Id, controller.selectedAccount.Id);
        system.assertEquals(td.case_1.Id, controller.caseList[0].Id);
        system.assertEquals(td.opportunity_1.Id, controller.selectedOpportunity.Id);
        
    }

    private static testMethod void test_oneContact() {
        ScreenPopControllerTestData td = new ScreenPopControllerTestData();
        td.createTestData_oneContact();
    
        Test.setFixedSearchResults(new List <Id>{td.contact_1.Id});
        PageReference pr = Page.ScreenPop;
        pr.getParameters().put('ANI', '5556667777');
        Test.setCurrentPage(pr);
        ScreenPopController controller = new ScreenPopController();
        
        system.assertEquals('5556667777', controller.ani);
        system.assertEquals(td.account_1.Id, controller.selectedAccount.Id);
        system.assertEquals(td.case_1.Id, controller.caseList[0].Id);
        system.assertEquals(td.opportunity_1.Id, controller.selectedOpportunity.Id);
        
    }
    
}
@isTest
public class ServiceRequestCaseTeamTest {

    private static testMethod void test_ownerUser() {
        ServiceRequestCaseTeamTestData td = new ServiceRequestCaseTeamTestData();    
        td.createTestData_ownerUser();
    
        td.workOrder_1.OwnerId = td.user_1.Id;
        update td.workOrder_1;
        
        List <CaseTeamMember> ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(1, ctmList.size());
        system.assertEquals(td.user_1.Id, ctmList[0].MemberId);
        system.assertEquals('Service Request Owner', ctmList[0].TeamRole.Name);
                    
    }

    private static testMethod void test_ownerQueue() {
        ServiceRequestCaseTeamTestData td = new ServiceRequestCaseTeamTestData();    
        td.createTestData_ownerQueue();
    
        td.workOrder_1.OwnerId = td.queue_1.Id;
        update td.workOrder_1;
        
        List <CaseTeamMember> ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(0, ctmList.size());
                    
    }

    private static testMethod void test_existingTeam() {
        ServiceRequestCaseTeamTestData td = new ServiceRequestCaseTeamTestData();    
        td.createTestData_existingTeam();
    
        td.workOrder_1.OwnerId = td.user_1.Id;
        update td.workOrder_1;
        
        List <CaseTeamMember> ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(1, ctmList.size());
        system.assertEquals(td.user_1.Id, ctmList[0].MemberId);
                    
    }

    private static testMethod void test_flagOff() {
        ServiceRequestCaseTeamTestData td = new ServiceRequestCaseTeamTestData();    
        td.createTestData_flagOff();
    
        td.workOrder_1.OwnerId = td.user_1.Id;
        update td.workOrder_1;
        
        List <CaseTeamMember> ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(0, ctmList.size());
                    
    }

    private static testMethod void test_roleNotFound() {
        ServiceRequestCaseTeamTestData td = new ServiceRequestCaseTeamTestData();    
        td.createTestData_roleNotFound();
    
        td.workOrder_1.OwnerId = td.user_1.Id;
        update td.workOrder_1;
        
        List <CaseTeamMember> ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(0, ctmList.size());
                    
    }

}
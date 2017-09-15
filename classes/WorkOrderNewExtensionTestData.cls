@isTest
public class WorkOrderNewExtensionTestData {

    public Case case_1;
    public WorkOrder wo_1;
    
    public void createTestData() {
        case_1 = new Case();    
        insert new List <Case>{case_1};
        
        wo_1 = new WorkOrder();
        wo_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WorkOrder' AND DeveloperName = 'Service_Request'].Id;
        insert new List <WorkOrder>{wo_1};
    }

}
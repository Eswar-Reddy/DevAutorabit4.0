@isTest
public class ServiceRequestUtilTestData {
    public WorkOrder wo_1;
    public List <WorkOrder> woList;
    User user_1;
    
    public void createTestData() {
        wo_1 = new WorkOrder();
        wo_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WorkOrder' AND DeveloperName = 'Service_Request'].Id;
        insert new List <WorkOrder>{wo_1};
    }

    public void createTestDataBulk(Integer batchSize) {
        woList = new List <WorkOrder>();
        String recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WorkOrder' AND DeveloperName = 'Service_Request'].Id;
        for (Integer i=0; i<batchSize; i++) {
            woList.add(new WorkOrder(RecordTypeId = recordTypeId));
        }
        insert woList;
    }

    public void createCompletedDateTestData() {
        wo_1 = new WorkOrder();
        wo_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WorkOrder' AND DeveloperName = 'Service_Request'].Id;
        insert new List <WorkOrder>{wo_1};
    }

    public void createCompletedDateTestData_closed_insert() {
        wo_1 = new WorkOrder();
        wo_1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WorkOrder' AND DeveloperName = 'Service_Request'].Id;
        wo_1.Status = 'Closed';
        insert new List <WorkOrder>{wo_1};
    }
    
}
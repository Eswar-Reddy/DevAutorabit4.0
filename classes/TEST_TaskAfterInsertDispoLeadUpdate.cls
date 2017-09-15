@isTest
 

public class TEST_TaskAfterInsertDispoLeadUpdate {

    static TestMethod void testLeadStatusUpdate() {

        List<F9CallDispositions__c> f9Settings = TestClassFactory.createCallDispositionSettings();
        insert f9Settings;
        
        List<String> callDispos = new List<String>();
        for(F9CallDispositions__c f : F9CallDispositions__c.getAll().values()) {
            callDispos.add(f.Name);
        }
        
        List<Lead> newLeads = new List<Lead>();
        for(Integer i = 0; i < callDispos.size(); i++) {
            Lead l = TestClassFactory.testLead('TestDispo' + i, 'TestDispo' + i, String.valueOf(Date.today()) + 'test' + i + '@example.com');
            l.Status = 'Sales Accepted';
            newLeads.add(l);
            i++;
        }
        
        insert newLeads;
        
        Test.startTest();
        
        //go down the mapping list assert that lead status matches expected results at the end of each update
        Integer i = 0;
        List<Task> callTaskList = new List<Task>();
        for(lead l : newLeads) {
            String dispo = callDispos[i];
            Task t = TestClassFactory.testF9CallTask(l.Id);
            t.Five9__Five9AgentExtension__c = 'Agent 007';
            t.CallDisposition = dispo;
            t.Status = 'Completed';
            t.Completed_Date__c = System.now();
            callTaskList.add(t);
            i++;
        }

        
        insert callTaskList;
        Test.stopTest();
                
    }
}
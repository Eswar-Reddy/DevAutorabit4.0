/****************************************************************************************
AUTHOR: Bharti Mehta(Appirio)
DATE: 28-July-2011
DESCRIPTION: TEST THE LAST SUBMISSION DATE ASSIGNED BY TRIGGER
*****************************************************************************************/
@isTest
private class UpdateLeadLastSubmissionDateTest {
	
	 //variables
	 static List<Lead> leadList = new List<Lead>();
    
    //Test Trigger : Lead Last Submission Date would be set as Task CreatedDate
    static testMethod void checkLastSubmissionDateUpdate() {    	
    	initializeTest();
    	
        //Start Test
        test.startTest(); 
        
        insertTasks();
         
        //Stop Test
        test.stopTest();
                
        //Query Leads
        Map<Id,Lead> mapLeads = new Map<Id,Lead>([Select Last_Submission_Date__c From Lead where Id IN : leadList]);
                
        //Query Tasks
        List<Task> newTaskList = [Select WhoId, CreatedDate From Task where WhoId IN : leadList];
        
        //verify Last_Submission_Date__c value 
        for(Task task: newTaskList){	
        	System.assertEquals(mapLeads.get(task.WhoId).Last_Submission_Date__c , task.CreatedDate);
        }       
        
    }
    
    static void initializeTest()
    {    	
    	//Create Lead
        Lead lead1 = new Lead();
        lead1.Status = 'Open';
        lead1.CurrencyIsoCode='USD';
        lead1.LeadSource='Web';
        lead1.SPWR_Industry_Type__c='Energy Developer';
        lead1.Business_Unit__c='RLC';
        lead1.Theater__c='Europe';
        lead1.LastName='Soral';
        lead1.Email='newlead1@gmail.com';
        leadList.add(lead1);
        
        //Create Lead
        Lead lead2 = new Lead();
        lead2.Status = 'Open';
        lead2.CurrencyIsoCode='USD';
        lead2.LeadSource='Web';
        lead2.SPWR_Industry_Type__c='Energy Developer';
        lead2.Business_Unit__c='RLC';
        lead2.Theater__c='Europe';
        lead2.LastName='Gour';
        lead2.Email='newlead2@gmail.com';
        leadList.add(lead2);
        
        //Insert Lead List
		insert leadList;
    }
    
    static void insertTasks(){  
	 List<Task> taskList = new List<Task>();
	 for(Lead lead : leadList){
	 	Task tsk = new Task();
	    tsk.Subject='Form: IT B2C Website Lead Form';
	    tsk.Status='Completed';
	    tsk.Priority='Normal';
	    tsk.ReminderDateTime=datetime.parse('7/28/2011 08:00 AM');
	    tsk.WhoId = lead.Id;
	    taskList.add(tsk);
	 }
	 insert taskList;
    }
}
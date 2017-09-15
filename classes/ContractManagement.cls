public class ContractManagement {

    public static void beforeContractInsert (List<Contract> contractList)
    {
    	//Case#00106338 Commneted code to set endDate
        //PR-02173
        //When a contract is created and the Contract End Date is blank, default the value to the last day of the year 
        //(e.g. 12/31/2009). It should default correctly every year
        
        /*DateTime dt = DateTime.Now();
        for(Contract con:contractList){
        	if(con.EndDate == null){
        		String str = dt.Year() + '-12-31';
        		con.EndDate = Date.valueOf(str);
        		
        	}
        }*/
                
    }

    public static void beforeContractUpdate (List<Contract> contractList, 
        List<Contract> oldContractList)
    {

        for(Contract con:contractList){
        	
        	if(con.StartDate == null && con.CompanySignedDate != null){        		        		
        		con.StartDate = con.CompanySignedDate;        		
        	}
        	
        	if (con.Signed_Date__c!=null && con.CustomerSignedDate==null){

        		con.CustomerSignedDate=con.Signed_Date__c;
        	}

		}
     
         
    }
    
    public static void afterContractUpdate (Map<ID,Contract> contractList, 
        Map<ID,Contract> oldContractList)
        {
            
            List<Task> taskList = new List<Task>();
            
            //Fetch all Customer asscoiated Users
            Map<ID,ID> conUser = new Map<ID,ID>();
        
            Set <ID> contactIds = new Set<ID>();
            
            for(Contract c : contractList.values()){
               if(c.CustomerSignedId != null){
                   contactIds.add(c.CustomerSignedId);
               }             
            }


            for(User u: [select ID,contactID from User 
                where contactid in :contactIds and UserType = 'PowerPartner']){
                conUser.put(u.contactID,u.ID);
            }
        
            for(Contract c : contractList.values()){
 
                if(c.X30_Days_Before_Contract_Deadline__c 
                    && !(oldContractList.get(c.ID).X30_Days_Before_Contract_Deadline__c))
                    taskList.add(createTask(c,conUser));
                else if(c.X45_Days_Before_Contract_Deadline__c 
                    && !(oldContractList.get(c.ID).X45_Days_Before_Contract_Deadline__c))
                    taskList.add(createTask(c,conUser));
                else if(c.X15_Days_Before_Contract_Deadline__c 
                    && !(oldContractList.get(c.ID).X15_Days_Before_Contract_Deadline__c))
                    taskList.add(createTask(c,conUser));
                else if(c.X7_Days_Before_Contract_Deadline__c 
                    && !(oldContractList.get(c.ID).X7_Days_Before_Contract_Deadline__c))
                    taskList.add(createTask(c,conUser));

            }
        
            if(taskList.size()>0)
                upsert taskList;
    }
    
    private static Task createTask(Contract c, Map<ID,ID> conUser){
            Task t = new Task();
            t.Subject = 'Contract';
            t.Priority ='High';
            t.WhatId = c.Id;
            t.whoID = c.CustomerSignedId;

            if(conUser.get(c.CustomerSignedId) != null){
                t.OwnerId = conUser.get(c.CustomerSignedId);
            }
            
            return t;
    }    
    
    private static void updateContract(List<Contract> contractList){

    }
}
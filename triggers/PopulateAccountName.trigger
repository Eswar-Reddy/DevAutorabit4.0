/** 
 Trigger Name: PopulateAccountName 
 Trigger Type: Before Insert and Before Update
 Object Name: order detail sunrise2  
 Purpose: Whenever any data in coming through Cast-Iron and getting 
          Inserted/updated, this trigger will populate the Account Name 
          based on the Customer number
 Action: Immediately after the integration
 Created By: Accenture
 Created Date: 15.05.2010(dd/mm/yyyy)
 Present Status: Active
 Change Log: 
             15.05.2010 > Initial Version Created  

**/



trigger PopulateAccountName on order_detail_sunrise2__c (before Insert,before Update) {
    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    Set<String> oracleCustNo = new Set<String>();
    Map<String,Id> accMap = new Map<String,Id>();
    for(order_detail_sunrise2__c o: Trigger.new){
    	if(o.Oracle_Customer_No__c!=null){
        	oracleCustNo.add(o.Oracle_Customer_No__c);
    	}    
    }
    for(List<Account> acclist : [Select Id, Oracle_Account_Number__c from Account where Oracle_Account_Number__c IN :oracleCustNo]){
        for(Account a: acclist){
            accMap.put(a.Oracle_Account_Number__c,a.Id);    
        }
    }
    
    for(Integer i=0; i<Trigger.New.size(); i++){
        Id aId = accMap.get(Trigger.new[i].Oracle_Customer_No__c);
        Trigger.new[i].Account_Name__c = aId;    
    }

}
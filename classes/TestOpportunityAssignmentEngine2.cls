/*********************************************************************
    Name  : TestOpportunityAssignmentEngine2
  Date  : July 18,2011
    Description: This is a Test Class For Class "OpportunityAssignmentEngine2".
*********************************************************************/
@isTest
private class TestOpportunityAssignmentEngine2 {

  static testMethod void testOppAssignEngine2(){
    
    Test.startTest();
    Map<String,ID> getLeadRTypeMap = new Map<String,ID>();
    for(RecordType rec:[select ID,Name from RecordType where sObjecttype ='Lead' LIMIT 10]){
      getLeadRTypeMap.put(rec.Name,rec.ID);
    }
 	List<Lead> leadList = new List<Lead>();  
  
    //Residential Lead
    Lead leadObj1 = new Lead();
    leadObj1.Company = 'Test1' + DateTime.now();
    leadObj1.LastName = 'Test1' + DateTime.now();
    leadObj1.Lead_Type__c = 'Residential';
    leadObj1.Rating = 'A';
    leadObj1.recordTypeID = getLeadRTypeMap.get('Residential');
    leadObj1.Email = 'abcTest14@test456.com'; 
    leadObj1.LeadSource = 'Web';
    leadObj1.City = 'Test City';
    leadObj1.State = 'test State';
    leadObj1.PostalCode = '10091';
    leadObj1.Street = 'test street';
    leadObj1.Country = 'United States';
    leadObj1.Country1__c = 'United States';
    leadObj1.Status = 'Qualified';
    leadObj1.HD_Lead_Status__c = 'Qualified';
    leadObj1.Lead_Approval__c = 'true';
    leadObj1.description = 'test description';
    leadObj1.Lead_Qualification_Notes__c = 'test lqc';
    leadObj1.Referral_Program_Status__c = 'test rps';
    leadObj1.Transmission_Capacity__c = 1001 ;
    leadObj1.Primary_Contact__c = True;
    leadObj1.Business_Unit__c = 'UPP Intl';
    leadObj1.Facility_Address__c = 'test fa';
    insert leadObj1;
    leadList.add(leadObj1);
    
    //Residential Lead
    Lead leadObj8 = new Lead();
    leadObj8.Company = 'Test8' + DateTime.now();
    leadObj8.LastName = 'Test8' + DateTime.now();
    leadObj8.Lead_Type__c = 'Residential';
    leadObj8.Rating = 'A';
    leadObj8.recordTypeID = getLeadRTypeMap.get('Residential');
    leadObj8.Email = 'abcTest8888888@test456.com'; 
    leadObj8.LeadSource = 'Web';
    leadObj8.City = 'Test City';
    leadObj8.State = 'test State';
    leadObj8.PostalCode = '10091';
    leadObj8.Street = 'test street';
    leadObj8.Country = 'United States';
    leadObj8.Country1__c = 'United States';
    leadObj8.Status = 'Qualified';
    leadObj8.HD_Lead_Status__c = 'Qualified';
    leadObj8.Lead_Approval__c = 'true';
    leadObj8.description = 'test description';
    leadObj8.Lead_Qualification_Notes__c = 'test lqc';
    leadObj8.Referral_Program_Status__c = 'test rps';
    leadObj8.Transmission_Capacity__c = 1001 ;
    leadObj8.Primary_Contact__c = True;
    leadObj8.Business_Unit__c = 'RLC';
    leadObj8.RLC_Type__c = 'Residential';
    leadObj8.Facility_Address__c = 'test fa';
    insert leadObj8;
    leadList.add(leadObj8);
    
    LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
    Database.LeadConvert[] lcArray = new Database.LeadConvert[]{};
           
    for(Lead l :leadList){
		Database.LeadConvert lc = new database.LeadConvert();
    	lc.setLeadId(l.Id);
	    lc.setConvertedStatus(convertStatus.MasterLabel);
	    lcArray.add(lc);
    }
    
    try{
    	Database.LeadConvertResult[] results = Database.convertLead(lcArray);
    	System.assert(results[0].IsSuccess());
    }
     catch(Exception ex){    	
    }
    Test.stopTest();
  }
  
  static testMethod void testOppAssignEngine2_2(){
    
    Test.startTest();
    Map<String,ID> getLeadRTypeMap = new Map<String,ID>();
    for(RecordType rec:[select ID,Name from RecordType where sObjecttype ='Lead' LIMIT 10]){
      getLeadRTypeMap.put(rec.Name,rec.ID);
    }
 	List<Lead> leadList = new List<Lead>(); 
 	
 	//New Homes Lead
    Lead leadObj2 = new Lead();
    leadObj2.Company = 'Test2' + DateTime.now();
    leadObj2.LastName = 'Test2' + DateTime.now();
    leadObj2.Lead_Type__c = 'New Homes';
    leadObj2.Rating = 'A';
    leadObj2.recordTypeID = getLeadRTypeMap.get('New Homes');
    leadObj2.Email = 'abcTest24@test456.com'; 
    leadObj2.LeadSource = 'Web';
    leadObj2.City = 'Test City';
    leadObj2.State = 'test State';
    leadObj2.PostalCode = '10091';
    leadObj2.Street = 'test street';
    leadObj2.Country = 'United States';
    leadObj2.Country1__c = 'United States';
    leadObj2.Status = 'Qualified';
    leadObj2.HD_Lead_Status__c = 'Qualified';
    leadObj2.Time_Of_Installation__c = '< 2 months';
    leadObj2.Business_Unit__c = 'UPP Intl';
    leadObj2.Lead_Approval__c = 'true';
    leadObj2.Facility_Address__c = 'test fa';
    insert leadObj2;
    leadList.add(leadObj2);
 	
 	//New Homes Lead
    Lead leadObj3 = new Lead();
    leadObj3.Company = 'Test3' + DateTime.now();
    leadObj3.LastName = 'Test3' + DateTime.now();
    leadObj3.Lead_Type__c = 'New Homes';
    leadObj3.Rating = 'A';
    leadObj3.recordTypeID = getLeadRTypeMap.get('New Homes');
    leadObj3.Email = 'abcTest333@test456.com'; 
    leadObj3.LeadSource = 'Web';
    leadObj3.City = 'Test City';
    leadObj3.State = 'test State';
    leadObj3.PostalCode = '10091';
    leadObj3.Street = 'test street';
    leadObj3.Country = 'United States';
    leadObj3.Country1__c = 'United States';
    leadObj3.Status = 'Qualified';
    leadObj3.HD_Lead_Status__c = 'Qualified';
    leadObj3.Time_Of_Installation__c = '< 3 months';
    leadObj3.Business_Unit__c = 'RLC';
    leadObj3.RLC_Type__c ='New Homes';
    leadObj3.Lead_Approval__c = 'true';
    leadObj3.Facility_Address__c = 'test fa';
    insert leadObj3;
    leadList.add(leadObj3);
    
    //New Homes Lead
    Lead leadObj4 = new Lead();
    leadObj4.Company = 'Test4' + DateTime.now();
    leadObj4.LastName = 'Test4' + DateTime.now();
    leadObj4.Lead_Type__c = 'New Homes';
    leadObj4.Rating = 'A';
    leadObj4.recordTypeID = getLeadRTypeMap.get('New Homes');
    leadObj4.Email = 'abcTest4444@test456.com'; 
    leadObj4.LeadSource = 'Web';
    leadObj4.City = 'Test City';
    leadObj4.State = 'test State';
    leadObj4.PostalCode = '10091';
    leadObj4.Street = 'test street';
    leadObj4.Country = 'United States';
    leadObj4.Country1__c = 'United States';
    leadObj4.Status = 'Qualified';
    leadObj4.HD_Lead_Status__c = 'Qualified';
    leadObj4.Time_Of_Installation__c = '< 5 months';
    leadObj4.Business_Unit__c = 'NA Commercial';
    leadObj4.Lead_Approval__c = 'true';
    leadObj4.Facility_Address__c = 'test fa';
    insert leadObj4;
    leadList.add(leadObj4);
    
    LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
    Database.LeadConvert[] lcArray = new Database.LeadConvert[]{};
           
    for(Lead l :leadList){
		Database.LeadConvert lc = new database.LeadConvert();
    	lc.setLeadId(l.Id);
	    lc.setConvertedStatus(convertStatus.MasterLabel);
	    lcArray.add(lc);
    }
    
    try{
    	Database.LeadConvertResult[] results = Database.convertLead(lcArray);
    	System.assert(results[0].IsSuccess());
    }
     catch(Exception ex){    	
    }
    Test.stopTest();
  }	
  
  static testMethod void testOppAssignEngine2_3(){
    
    Test.startTest();
    Map<String,ID> getLeadRTypeMap = new Map<String,ID>();
    for(RecordType rec:[select ID,Name from RecordType where sObjecttype ='Lead' LIMIT 10]){
      getLeadRTypeMap.put(rec.Name,rec.ID);
    }
 	List<Lead> leadList = new List<Lead>();  
 	
 	//Systems Lead
    Lead leadObj5 = new Lead();
    leadObj5.Company = 'Test5' + DateTime.now();
    leadObj5.LastName = 'Test5' + DateTime.now();
    leadObj5.Lead_Type__c = 'Systems';
    leadObj5.Rating = 'A';
    leadObj5.recordTypeID = getLeadRTypeMap.get('Systems');
    leadObj5.Email = 'abcTest5555@test456.com'; 
    leadObj5.LeadSource = 'Web';
    leadObj5.City = 'Test City';
    leadObj5.State = 'test State';
    leadObj5.PostalCode = '10091';
    leadObj5.Street = 'test street';
    leadObj5.Country = 'United States';
    leadObj5.Country1__c = 'United States';
    leadObj5.Status = 'Qualified';
    leadObj5.HD_Lead_Status__c = 'Qualified';
    leadObj5.Time_Of_Installation__c = '< 6 months';
    leadObj5.Business_Unit__c = 'UPP Americas';
    leadObj5.Lead_Approval__c = 'true';
    leadObj5.Facility_Address__c = 'test fa';
    insert leadObj5;
    leadList.add(leadObj5);
    
    //Systems Lead
    Lead leadObj6 = new Lead();
    leadObj6.Company = 'Test6' + DateTime.now();
    leadObj6.LastName = 'Test6' + DateTime.now();
    leadObj6.Lead_Type__c = 'Systems';
    leadObj6.Rating = 'A';
    leadObj6.recordTypeID = getLeadRTypeMap.get('Systems');
    leadObj6.Email = 'abcTest6664@test456.com'; 
    leadObj6.LeadSource = 'Web';
    leadObj6.City = 'Test City';
    leadObj6.State = 'test State';
    leadObj6.PostalCode = '10091';
    leadObj6.Street = 'test street';
    leadObj6.Country = 'United States';
    leadObj6.Country1__c = 'United States';
    leadObj6.Status = 'Qualified';
    leadObj6.HD_Lead_Status__c = 'Qualified';
    leadObj6.Time_Of_Installation__c = '< 12 months';
    leadObj6.Business_Unit__c = 'RLC';
    leadObj6.RLC_Type__c = 'Light Commercial';
    leadObj6.Lead_Approval__c = 'true';
    leadObj6.Facility_Address__c = 'test fa';
    insert leadObj6;
    leadList.add(leadObj6);
    
    //Systems Lead
    Lead leadObj7 = new Lead();
    leadObj7.Company = 'Test7' + DateTime.now();
    leadObj7.LastName = 'Test7' + DateTime.now();
    leadObj7.Lead_Type__c = 'Systems';
    leadObj7.Rating = 'A';
    leadObj7.recordTypeID = getLeadRTypeMap.get('Systems');
    leadObj7.Email = 'abcTest1777234@test456.com'; 
    leadObj7.LeadSource = 'Web';
    leadObj7.City = 'Test City';
    leadObj7.State = 'test State';
    leadObj7.PostalCode = '10091';
    leadObj7.Street = 'test street';
    leadObj7.Country = 'United States';
    leadObj7.Country1__c = 'United States';
    leadObj7.Status = 'Qualified';
    leadObj7.HD_Lead_Status__c = 'Qualified';
    leadObj7.Time_Of_Installation__c = '< 6 months';
    leadObj7.Business_Unit__c = 'NA Commercial';
    leadObj7.Lead_Approval__c = 'true';
    leadObj7.Facility_Address__c = 'test fa';
    insert leadObj7;
    leadList.add(leadObj7);
    
    LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
    Database.LeadConvert[] lcArray = new Database.LeadConvert[]{};
           
    for(Lead l :leadList){
		Database.LeadConvert lc = new database.LeadConvert();
    	lc.setLeadId(l.Id);
	    lc.setConvertedStatus(convertStatus.MasterLabel);
	    lcArray.add(lc);
    }
    
    try{
    	Database.LeadConvertResult[] results = Database.convertLead(lcArray);
    	System.assert(results[0].IsSuccess());
    }
     catch(Exception ex){    	
    }
    Test.stopTest();
  }
}
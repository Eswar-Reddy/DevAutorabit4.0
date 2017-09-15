@isTest(seeAllData = true)
private class TestDocGenCommercial {

 	static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
  
   
    static testmethod void unitTest(){
        String postFix = String.valueOf(Datetime.now().getTime());
		newAccount = TestUtils.createAccount('TestCommercialAccount' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TestCommercialContact' + postFix, newAccount.Id, true);
        
        List<Opportunity > oppList = new List<Opportunity >();
        Opportunity opp = new Opportunity();
     	newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
		newOpportunity.Business_Unit__c = 'NA Commercial';
		newOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Systems');
        newOpportunity.StageName = '01 - Build Single Sales Objective';
        newOpportunity.Country__c = 'United States';
        newOpportunity.Sub_Region__c = 'California - North';
        newOpportunity.Customer_selection_process__c = 'Test Customer selection process';
        newOpportunity.My_Position_vs_Competition__c = 'Test My position v/s compition';
        newOpportunity.Closure_Deal_Risks__c = 'Test closure deal risks';
        newOpportunity.Proposal_Due_Date__c = System.today();      
        update newOpportunity; 		
		Test.startTest();
		List<Pricebook2> pbList = [Select Id From Pricebook2 where Name ='Standard Price Book' limit 1];
        Id pbId;
        if(pbList.size()>0)
            pbId = pbList.get(0).Id;
        Product2 p = new Product2(Name = 'TestProduct', IsActive = true, Family='PV Cell', Product_Type__c = 'PV Module', Unit__c =1000);
        insert p;
        
        PricebookEntry pe = new PricebookEntry(Product2Id = p.Id, Pricebook2Id = pbId, IsActive = true, UnitPrice = 10.0);
        insert pe;  
        
        OpportunityLineItem oppLine = new OpportunityLineItem();
        oppLine.OpportunityId = newOpportunity.Id;
        oppLine.PricebookEntryId = pe.Id;
        oppLine.UnitPrice = 5.0;
        oppLine.Quantity = 2.0; 
        insert oppLine;
    	System.debug('**oppLine==>'+oppLine);
    	List<Opportunity_Score__c> listScore = new List<Opportunity_Score__c>();
    	for(Integer i=0; i<=1 ; i++){
			Opportunity_Score__c oppScore = new Opportunity_Score__c();		
	        oppScore.Opportunity__c = newOpportunity.Id;
	        if(i==0)
	        	oppScore.Main_Category__c = 'Design/Product/EPC';
	        else
	        	oppScore.Main_Category__c = 'Business Case';
	        oppScore.Sub_Category__c = 'Sub';
	        oppScore.Category__c = 'Cat';	
			oppScore.Max_Score__c = 5;
			listScore.add(oppScore);
    	}
		insert listScore;
		System.debug('**listScore==>'+listScore);
		DocGenCommercial docGen = new DocGenCommercial();
		docGen.settings = DocGenCommercial__c.getAll().values();
        docGen.loadSettings();
        docGen.sendDataToDocGen(newOpportunity.Id,'No','Commercial','PR0');
        
        //Negative testing
        Test.stopTest();
    }

}
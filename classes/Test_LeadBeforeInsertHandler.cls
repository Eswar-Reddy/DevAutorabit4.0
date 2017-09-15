@isTest
public with sharing class Test_LeadBeforeInsertHandler {
	
	private static ID ResidentialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SobjectType).get('Residential');

	@isTest
	public static void testLeadBeforeInsertBasicFieldAssignment(){
		//test to make sure autoconvert is set to true or false correctly
		ID accountResidentialRT = TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer');
		Account dealerAccount = TestClassFactory.testAccount('DealerAccount',accountResidentialRT);
		insert dealerAccount;

		

		Lead l = TestClassFactory.testLead('TestOne','TestOne','testOne@leadTest.com');
		l.RecordTypeId = ResidentialRecordTypeId;//residential record type lead
		//RLC_type__c should go to "Residential"
		//Primary Contact should be set to "True"

		//after insert, the lead's Dealer_Locator_Selection should be set to the test dealer Account
		//l.Dealer_Name__c = 'DealerAccount';
		
		//this should get changed to United States and the theater should be set to "North America" based on the Country_Reference object
		Country_Reference__c cr = new Country_Reference__c(Country__c = 'United States', Theater__c = 'North America');
		insert cr;
		//l.Country = 'US';
		l.Country = 'United States';
		l.Street = '123 Test St';
		l.City = 'Denver';
		l.State = 'CO';
		l.PostalCode = '80209';

		l.SPWR_Industry_Type__c = 'Test Industry Type';
		//the HD_ version of this field should get 'Test Industry Type'


		l.leadSource = 'Jigsaw';//should get changed to "Data.Com - Sales"

		l.First_follow_up__c = true;
		//assert Date_Time_First_follow_up__c = todayish
	    l.Second_follow_up__c = true;
	    //    l.Date_Time_Second_follow_up__c = Datetime.now();
	    l.Third_follow_up__c = true;
	    //    l.Date_Time_Third_follow_up__c = Datetime.now();
	    l.Fourth_follow_up__c = true;
	    //    l.Date_Time_Fourth_follow_up__c = Datetime.now();
	    l.Fifth_follow_up__c = true;
	    //    l.Date_Time_Fifth_follow_up__c = Datetime.now();
	    l.Business_Unit__c = 'Test Business Unit';

	    test.startTest();
	    insert l;
	    /*
	    l = [Select ID, 
	    			Dealer_Locator_Selection__c,//dealerAccount.id 
	    			RLC_Type__c, //Residential
	    			Primary_Contact__c, //true
	    			Theater__c, //North America
	    			SPWR_Industry_Type_Hidden__c,//Test Industry Type
	    			LeadSource,//Data.Com - Sales
	    			Country,//United States
	    			Lead_Owner_Mapping__c,//current user
	    			Date_Time_First_follow_up__c,//today
	    			Date_Time_Second_follow_up__c,//today
	    			Date_Time_Third_follow_up__c,//today
	    			Date_Time_Fourth_follow_up__c,//today
	    			Date_Time_Fifth_follow_up__c,//today
	    			HD_Business_Unit__c,//Test Business Unit
	    			HD_Lead_Status__c//open
	    			from Lead where ID = : l.id
	    			];

	    //system.assert(l.Dealer_Locator_Selection__c==dealerAccount.id);
	    system.assert(l.RLC_Type__c == 'Residential');
	    system.assert(l.Primary_Contact__c);
	    system.assert(l.Theater__c == 'North America');
	    system.assert(l.SPWR_Industry_Type_Hidden__c == 'Test Industry Type');
	    system.assert(l.LeadSource == 'Data.com - Sales');
	    system.assert(l.Country__c == 'United States');
	    system.assert(l.HD_Business_Unit__c =='Test Business Unit');
	    Date today = system.today();
	    system.assert(
	    				l.Date_Time_First_follow_up__c.date() == today &&
	    				l.Date_Time_Second_follow_up__c.date() == today &&
	    				l.Date_Time_Third_follow_up__c.date() == today &&
	    				l.Date_Time_Fourth_follow_up__c.date() == today &&
	    				l.Date_Time_Fifth_follow_up__c.date() == today

	    			);*/
	    test.stopTest();


	}	

	
}
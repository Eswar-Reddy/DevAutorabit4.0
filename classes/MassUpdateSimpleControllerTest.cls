/**
 * This class contains unit tests for validating the behavior of MassUpdateController
 * and triggers.
 */
@isTest
private class MassUpdateSimpleControllerTest {


    static testMethod void singleUpdateTest() {
    	Opportunity o = new Opportunity();
    	List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
    	setCtr.setSelected(new Opportunity[]{o});
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
		System.assertEquals(1, controller.getRecordSize());
		
		System.assert(controller.getFieldTypeOptions().size()>1);
		
		system.assertEquals(1, controller.objsToUpdate.size());
		
		String value = '123test';
		controller.fieldName='name';
		controller.valueToUpdate=value;	
		//controller.convertedFieldData = controller.convertUserInputToFieldData();	
		controller.step4();
		controller.step5();
		
		System.assert(o.name==value);
		
	    value ='123';
	    controller.step3();
	    controller.fieldName='amount';
	    controller.valueToUpdate=value;	
	    controller.step4();
	    controller.step5();
	    
	    System.assert(o.amount==decimal.valueOf(value));
	    
/*	    value ='true';
	    controller.fieldName='IsPrivate';
	    controller.step3();
	    controller.valueToUpdate=value;		
	    controller.step4();
	    controller.step5();
	    
	    System.assert(o.IsPrivate); */
	    // make sure no exception from display tips
	    System.assertEquals(controller.getFieldInfoToDisplay()!=null,true);
	    	    
	    value ='2009-4-7';
	    controller.fieldName='CloseDate';
	    controller.valueToUpdate=value;		
	    controller.step4();
	    controller.step5();
	    System.assert(o.CloseDate==Date.valueOf(value));
	    
	    value ='Closed';
	    controller.fieldName='StageName';
	    controller.valueToUpdate=value;		
	    controller.step4();
	    controller.step5();
	    System.assert(o.StageName=='Closed');
    }
    
 /*   static testMethod void massUpdateAsStandardUserTest() {
    	
    	Profile p = [select id from profile where name='Standard User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com');
    	
    	System.runAs(u) {
    	  Opportunity o = new Opportunity();
    	  List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
    	
    	  ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
    	  setCtr.setSelected(new Opportunity[]{o});
          MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
		  System.assertEquals(1, controller.getRecordSize());
		
		  System.assert(controller.getFieldTypeOptions().size()>1);
		
		  system.assertEquals(1, controller.objsToUpdate.size());
		
		  String value = '123test';
		  controller.fieldName='name';
		  controller.valueToUpdate=value;		
		  controller.save();
		
		  System.assert(o.name==value);
		 
    	}
    }  */
    
    static testMethod void linkTest() {
    	Opportunity o = new Opportunity();
    	List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
    	setCtr.setSelected(new Opportunity[]{o});
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
		
		// verify following exceptions will not cause exception
		System.assert(controller.step1()!=null);
		System.assert(controller.step2()!=null);
		System.assert(controller.step3()!=null);
		System.assert(controller.step4()!=null);
		System.assert(controller.step5()!=null);
		//System.assert(controller.cancel()!=null);
		
		System.assert(controller.getFieldTypeOptions()!=null);
    }
    
    static testMethod void fieldTest() {
    	
    	List<Opportunity> oppList = new Opportunity[]{};
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
        System.assert(controller.cancel()!=null);
		System.assert(controller.getFieldTypeOptions()==null);
    }
    
    static testMethod void customFieldListTest() {
    	
    	List<LeasePayment__c> leasePayments = new List<LeasePayment__c>();
    	leasePayments.add( new LeasePayment__c() );
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController( leasePayments );
    	setCtr.setSelected( leasePayments );
    	
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
        
    	//custom settings setup
    	LeasePaymentFields__c leasePaymentField = new LeasePaymentFields__c();
    	leasePaymentField.Order__c = 1;
    	leasePaymentField.Field_Name__c = 'Name';
    	leasePaymentField.Type__c = 'Text';
    	leasePaymentField.Name = 'Name';
    	
    	MassUpdateSimpleController.customFieldList = new List<LeasePaymentFields__c>{ leasePaymentField };
    	
        Test.startTest();
        
        	List<SelectOption> options = controller.getCustomFieldTypeOptions();
        	
        Test.stopTest();	
        
        //includes a none select option
        System.assertNotEquals(null, options, 'The options list should not be null' );
        System.assertEquals( 2, options.size(), 'There should be two select options' );
        System.assertEquals( leasePaymentField.Field_Name__c, options[1].getValue(), 'The value should be the same as the field name of the custom setting.' );
        System.assertEquals(leasePaymentField.Name, options[1].getLabel(),'The label should be the same as the name of the field of the custom setting.');
    }
    
    static testMethod void customFieldListAndSelectTest() {
    	
    	List<LeasePayment__c> leasePayments = new List<LeasePayment__c>();
    	leasePayments.add( new LeasePayment__c() );
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController( leasePayments );
    	setCtr.setSelected( leasePayments );
        
    	//custom settings setup
    	LeasePaymentFields__c leasePaymentField = new LeasePaymentFields__c();
    	leasePaymentField.Order__c = 1;
    	leasePaymentField.Field_Name__c = 'Name';
    	leasePaymentField.Type__c = 'Text';
    	leasePaymentField.Name = 'Name';
    	
    	MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
    	
    	MassUpdateSimpleController.customFieldList = new List<LeasePaymentFields__c>{ leasePaymentField };
    	List<SelectOption> options = controller.getCustomFieldTypeOptions();
    	
        Test.startTest();
        	
        	controller.fieldName = options[1].getValue();
        	controller.step3();
        	
        Test.stopTest();	
        
        System.assertEquals( 'Name' , controller.fieldName, 'The type of the field should be of text.' );
    }
    
    static testMethod void setFieldInLeasePaymentTest() {
    	
    	Tranche_Batch__c testTrancheBatch = TestUtils.createTrancheBatch('testTrancheBatch', true);
    	
    	Account account = TestUtils.createAccount('testAccount', true);
    	
    	LeasePayment__c testLeasePayment = TestUtils.createLeasePayment('testLeasePayment', account.Id, true);
    	
    	testLeasePayment = [SELECT Id FROM LeasePayment__c WHERE Id = :testLeasePayment.Id];	
    	
    	List<LeasePayment__c> leasePayments = new List<LeasePayment__c>();
    	leasePayments.add( testLeasePayment);
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController( leasePayments );
    	setCtr.setSelected( leasePayments );
        
    	//custom settings setup
    	LeasePaymentFields__c leasePaymentField = new LeasePaymentFields__c();
    	leasePaymentField.Order__c = 1;
    	leasePaymentField.Field_Name__c = 'Tranche_1_Batch__c';
    	leasePaymentField.Type__c = MassUpdateSimpleController.REFERENCE_TYPE;
    	leasePaymentField.Name = 'Tranche 1 Batch';
    	
    	MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
    	
    	MassUpdateSimpleController.customFieldList = new List<LeasePaymentFields__c>{ leasePaymentField };
    	List<SelectOption> options = controller.getCustomFieldTypeOptions();
    	
        Test.startTest();
        	
        	controller.fieldName = options[1].getValue();
        	controller.step3();
        	controller.leasePayment.put(leasePaymentField.Field_Name__c, testTrancheBatch.Id);
        	
        	controller.step4();
        	controller.step5();
        	
        	
        Test.stopTest();	
        
    	List<LeasePayment__c> queriedLeasePayments = [SELECT Id, Tranche_1_Batch__c FROM LeasePayment__c LIMIT 1];
    	    	
    	System.assertEquals(testTrancheBatch.Id ,queriedLeasePayments[0].Tranche_1_Batch__c ,'The lease payment\'s tranche batch field should have the tranche batch\'s id');
                
    }
    
    
    static testMethod void miscTest() {
    	
    	List<Opportunity> oppList = new Opportunity[]{};
    	
    	ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
		
		System.assert(controller.getNow(true)!=null);
		System.assert(controller.getNow(false)!=null);
		System.assert(controller.getRecordSize()==0);
		System.assert(controller.getPicklistValues()==null);
    }
}
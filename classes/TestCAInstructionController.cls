public class TestCAInstructionController {
@isTest
	public static void Test_CAInstructionController(){
		
		List<Account> accList = new List<Account>();
		Account acc1 = new Account(name= 'test1' + String.ValueOf(DateTime.Now()));
        acc1.Type ='Commercial';
        acc1.billingCity = 'TestCity';
	    acc1.BillingCountry = 'Spain';
	    acc1.BillingPostalCode = '12345';
	    acc1.BillingState = 'TestState';
	    acc1.BillingStreet = 'TestStreet';
        
        Account acc2 = new Account(name= 'test2' + String.ValueOf(DateTime.Now()));
        acc2.Type ='Commercial';
        acc2.billingCity = 'TestCity';
	    acc2.BillingCountry = 'Germany';
	    acc2.BillingPostalCode = '12345';
	    acc2.BillingState = 'TestState';
	    acc2.BillingStreet = 'TestStreet';
        
        Account acc3 = new Account(name= 'test3' + String.ValueOf(DateTime.Now()));
        acc3.Type ='Commercial';
        acc3.billingCity = 'TestCity';
	    acc3.BillingCountry = 'Italy';
	    acc3.BillingPostalCode = '12345';
	    acc3.BillingState = 'TestState';
	    acc3.BillingStreet = 'TestStreet';
        
        Account acc4 = new Account(name= 'test4' + String.ValueOf(DateTime.Now()));
        acc4.Type ='Commercial';
        acc4.billingCity = 'TestCity';
	    acc4.BillingCountry = 'France';
	    acc4.BillingPostalCode = '12345';
	    acc4.BillingState = 'TestState';
	    acc4.BillingStreet = 'TestStreet';
        
        accList.add(acc1);
        accList.add(acc2);
        accList.add(acc3);
        accList.add(acc4);
        insert accList;
		
		Credit_Application__c cs = new Credit_Application__c();        
    	
    	
    	ApexPages.standardController std = new ApexPages.standardController(cs);
    	CreditApplicationInstructionController obj = new CreditApplicationInstructionController(std);
    	ApexPages.currentPage().getParameters().put('accId', acc1.Id);
    	obj = new CreditApplicationInstructionController(std);
    	ApexPages.currentPage().getParameters().put('accId', acc2.Id);
    	obj = new CreditApplicationInstructionController(std);
    	ApexPages.currentPage().getParameters().put('accId', acc3.Id);
    	obj = new CreditApplicationInstructionController(std);
    	ApexPages.currentPage().getParameters().put('accId', acc4.Id);
    	obj = new CreditApplicationInstructionController(std);
    	
	}
}
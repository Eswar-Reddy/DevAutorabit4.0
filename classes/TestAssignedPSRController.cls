/********************************************************
**PR-01948
**By- Kapil Goutam
**On- June 17 2009
**Modified - 
**Modified On- 
**Description- Controller Class for AssignedPSRController
**********************************************************/
/********************************************************
**By- JAJA
**On- March 21 2015
**Increase Code Coverage
**********************************************************/
@isTest
public class TestAssignedPSRController {
	static Account accountObj;
    

	 public static account getAccount(){   
        UserManagement.IS_TEST = true;
        accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        accountObj.billingCity = 'TestCity';
	    accountObj.BillingCountry = 'TestCountry';
	    accountObj.BillingPostalCode = '12345';
	    accountObj.BillingState = 'TestState';
	    accountObj.BillingStreet = 'TestStreet';
        return accountObj;
    }
    
    @isTest
    public static void Test_AssignedPSRController_Save(){        
        
        accountObj = getAccount();
        insert accountObj;
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(accountObj);       
        
        AssignedPSRController obj = new AssignedPSRController(controller);
        obj.acct = accountObj;
        List<User> lstUser = [select Id from User where UserRole.Name like 'Partner Support Representative%' Limit 1];        
        obj.acct.Assigned_PSR_IDS__c = lstUser[0].Id;
        
        Test.startTest();
        obj.save1();
		Test.stopTest();  
        
		    
        System.assertEquals('save', obj.closeStatus);
        system.assertEquals(true,obj.getHasMessages());
    }
    
    @isTest
    public static void Test_AssignedPSRController_Save_ListofPSR(){       
        
        accountObj = getAccount();
        
        List<User> lstUser = [select Id from User where UserRole.Name like 'Partner Support Representative%' Limit 2];        
        string ids = lstUser[0].Id + ',' + lstUser[1].Id;
        accountObj.Assigned_PSR_IDS__c = ids;        
        
        insert accountObj;
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(accountObj);
        Apexpages.currentPage().getParameters().put('id', accountObj.Id);
        AssignedPSRController obj = new AssignedPSRController(controller);
                
        Test.startTest();
        List<User> listusr = obj.getPsrUsers();        
        List<SelectOption> lstOptions = obj.getPSRUsersOptions();        
        List<SelectOption> asslstOptions = obj.getAssignedPSRUsersOptions();   
        PageReference pf = obj.save1();        
		Test.stopTest(); 
        
		System.assertEquals( ids, accountObj.Assigned_PSR_IDS__c );      
        System.assertEquals('save', obj.closeStatus);
        system.assertEquals(false,obj.getHasMessages()); 
        
        system.assertNotEquals(null,lstOptions);
        system.assertNotEquals(null,listusr);
        system.assertNotEquals(null,asslstOptions);
        system.assertNotEquals(null,pf);
        
        system.assertEquals(listusr.size() - 2,lstOptions.size());
        system.assertEquals(2,asslstOptions.size());
        
    }
    
	@isTest
	public static void Test_AssignedPSRController_Cancel()
    {
        accountObj = getAccount();
        insert accountObj;
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(accountObj);
        Apexpages.currentPage().getParameters().put('id', accountObj.Id);
        AssignedPSRController obj = new AssignedPSRController(controller);
        
        Test.startTest();
        obj.cancel();
		Test.stopTest();  
		System.assertEquals(null,accountObj.Assigned_PSR_IDS__c);              
        System.assertEquals('close', obj.closeStatus); 
        system.assertEquals(false,obj.getHasMessages());   
  
    }
    
	@isTest
	public static void Test_AssignedPSRController_NotValidId()
    {             
        accountObj = getAccount();
        insert accountObj;
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(accountObj);   
        Apexpages.currentPage().getParameters().put('id', '123');
             
        Test.startTest();
        AssignedPSRController obj = new AssignedPSRController(controller);
        Test.stopTest();
        
		system.assertEquals('123',obj.accid); 
        system.assertEquals(true,obj.getHasMessages());
        System.assertEquals(null,accountObj.Assigned_PSR_IDS__c); 
    }
    @isTest
	public static void Test_AssignedPSRController_NullAccount()
    {             
        accountObj = getAccount();
        insert accountObj;
        ApexPages.Standardcontroller controller = new Apexpages.Standardcontroller(accountObj); 
        Apexpages.currentPage().getParameters().put('id', '');
        Test.startTest();
        AssignedPSRController obj = new AssignedPSRController(controller);        
        Test.stopTest();
        
		system.assertEquals('',obj.accid); 
        system.assertEquals(true,obj.getHasMessages());
        System.assertEquals(null,accountObj.Assigned_PSR_IDS__c); 
    }
    
    
}
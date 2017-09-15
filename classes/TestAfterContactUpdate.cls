/************************************
**PR-01948
**By- Kapil Goutam
**On- May 21 2009
**Modified - 
**Modified On- 
**Description- Test Class for trigger AfterContactUpdate
***************************************
**************************************/
public class TestAfterContactUpdate{
	public static Account accountObj;
	public static Contact contactObj;
	static{
		accountObj = new Account();
	    accountObj.Name = 'Testing' +String.valueOf(DateTime.Now());
	    accountObj.Type ='Commercial';
	    accountObj.billingCity = 'TestCity';
	    accountObj.BillingCountry = 'TestCountry';
	    accountObj.BillingPostalCode = '12345';
	    accountObj.BillingState = 'TestState';
	    accountObj.BillingStreet = 'TestStreet';
	    
	    accountObj.shippingCity = 'TestCity';
	    accountObj.shippingCountry = 'TestCountry';
	    accountObj.shippingPostalCode = '12345';
	    accountObj.shippingState = 'TestState';
	    accountObj.shippingStreet = 'TestStreet';    
	    insert accountObj;
	    
	    contactObj = new Contact();
	    contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
	    contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
	    //contactObj.Email = 'testB'+ String.ValueOf(Datetime.now())+'@nom.com';
	    contactObj.AccountId = accountObj.Id;
	    insert contactObj;
	}
    @isTest
  public static void Test_AfterContactUpdate(){
  
    /*Account accountObj = new Account();
    accountObj.Name = 'Testing' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    
    accountObj.shippingCity = 'TestCity';
    accountObj.shippingCountry = 'TestCountry';
    accountObj.shippingPostalCode = '12345';
    accountObj.shippingState = 'TestState';
    accountObj.shippingStreet = 'TestStreet';    
    insert accountObj;
      
    Contact contactObj = new Contact();
    contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
    contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
    //contactObj.Email = 'testB'+ String.ValueOf(Datetime.now())+'@nom.com';
    contactObj.AccountId = accountObj.Id;
    insert contactObj;*/
      
    Contact contactObjUpdated = new Contact(Id=contactObj.Id);
    contactObjUpdated.FirstName = 'Test' + String.valueOf(DateTime.Now()) + 'updated' ;
    Test.StartTest();
    update contactObjUpdated;
    Test.StopTest();
    /*TestCheckContactDuplicate.testcheckContactDuplicate();
    //TestContactManagement.Test_TerminatedContactUpdate();
    TestCertificationManagement.checkCertificationManagement();
    TestAccountManagement.Test_AccountUpdate();*/
  }
}
/*

Test diagnostics class

Class:              Test_Diagnostics
Date:               06/11/2014
Version:            1
Last Updated:       06/11/2014
    * 	Stubbed / Completed

////////////////////////////////////////////////////////////////////////////////
*/

@isTest
private class Test_Diagnostics
{	
	// -------- Variables --------
	// None
	
	// -------- Shared Methods --------
	// None
	
	// -------- Test Methods --------
	// Test complete run through simulating methods
	private static testMethod void completion()
	{
		Test.startTest();
		
		Diagnostics.push('Test Method 1');
		
		try
		{
			Integer x = 1;
			Integer y = 1;
			Integer z = x/y;
			
			Diagnostics.push('Test Method 2');
			Integer a = 0;
			a += 1;
			
			Diagnostics.pop();
			Diagnostics.pop();
		}
		catch (Exception error)
		{
			Diagnostics.exception(error);
		}
		
		Test.stopTest();
	}
	
	// Test first simulated method failure
	private static testMethod void failFirstMethod()
	{
		Test.startTest();
		
		Diagnostics.push('Test Method 1');
		
		try
		{
			Integer x = 0;
			Integer y = 0;
			Integer z = x/y;
			
			Diagnostics.push('Test Method 2');
			Integer a = 0;
			a += 1;
			
			Diagnostics.pop();
			Diagnostics.pop();
		}
		catch (Exception error)
		{
			Diagnostics.exception(error);
		}
		
		Test.stopTest();
	}
	
	// Test second simulated method failure
	private static testMethod void failSecondMethod()
	{
		Test.startTest();
		
		Diagnostics.push('Test Method 1');
		
		try
		{
			Integer x = 1;
			Integer y = 1;
			Integer z = x/y;
			
			Diagnostics.push('Test Method 2');
			Integer a;
			a += 1;
			
			Diagnostics.pop();
			Diagnostics.pop();
		}
		catch (Exception error)
		{
			Diagnostics.exception(error);
			Diagnostics.exceptionFatal(error);
		}
		
		Test.stopTest();
	}
}
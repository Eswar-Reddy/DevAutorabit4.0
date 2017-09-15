/*********************************************************************
    Name  : TestDateCalculationUtility
    Date  : July 19,2011
    Description:This is a Test Class For Class "DateCalculationUtility".
*********************************************************************/

@isTest
private class TestDateCalculationUtility {
    // when Date is used
    static testMethod void getWorkingDayDTest() {
        
        Date startDate = Date.newInstance(2011,7,18);
        
        Date expectedDate = Date.newInstance(2011,8,1);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,10));
        
        startDate = Date.newInstance(2011,7,15);
        expectedDate = Date.newInstance(2011,8,8);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,16));
        
        startDate = Date.newInstance(2011,7,15);
        expectedDate = Date.newInstance(2011,8,4);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,14));
        
        // when start Date is weekend
        startDate = Date.newInstance(2011,7,17);
        
        expectedDate = Date.newInstance(2011,8,4);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,13));
    }
	// when Date is used
    static testMethod void getWorkingDayDTTest() {
        
        DateTime startDate = DateTime.newInstance(2011,7,18);
        
        DateTime expectedDate = DateTime.newInstance(2011,8,1);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,10));
        
        startDate = DateTime.newInstance(2011,7,15);
        expectedDate = DateTime.newInstance(2011,8,8);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,16));
        
        startDate = DateTime.newInstance(2011,7,15);
        expectedDate = DateTime.newInstance(2011,8,4);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,14));
        
        // when start Date is weekend
        startDate = DateTime.newInstance(2011,7,17);
        
        expectedDate = DateTime.newInstance(2011,8,4);
        System.AssertEquals(expectedDate , DateCalculationUtility.getWorkingDay(startDate,13));
    }
}
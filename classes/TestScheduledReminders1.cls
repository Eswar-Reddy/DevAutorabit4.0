/***************************************************
    Test Class For Class "ScheduledReminders1".
****************************************************/

@isTest
private class TestScheduledReminders1 {

    static testMethod void testSchedule() {
    SchedulableContext SC;
    scheduledReminders1 schRem = new scheduledReminders1();
        schRem.execute(SC);
        Test.startTest();
        schRem.executeFunction();
        Test.stopTest();
    
    }

}
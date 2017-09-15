/*****
=============
CLASS DETAILS
=============
Class Name: SPWR_Spectrum_Debug_Log_Schedulable_Test
Author: Kane Chelster Macaspac

Description:
This is a test class for SPWR_Spectrum_Debug_Log_Schedulable.  As reference, the batch class is supposed to delete records that match
the criteria below:
1. Service__c starts with SO and older than 45 days
2. Service__c is SPD Lead/Five9 Web2Campaign and older than 45 days
3. Service__c is GeoCallOut to Google and older than 15 days
4. All other services older than 180 days that does not contain Mosaic or Agreement 

==============
CHANGE HISTORY
==============
Version: n/a
Author: n/a
Last Modified Date/Time: n/a
Details: n/a

*****/

@isTest
private class SPWR_Spectrum_Debug_Log_Schedulable_Test {
    static testMethod void testBatchSchedule() {
        List<Sunpower_Spectrum_Debug_Log__c> ssdl = SPWR_Spectrum_Debug_Log_TestDataFactory.generateSSDL();

        insert ssdl;
        
        Test.startTest();
        String jobId = System.schedule('Test SPWR_Spectrum_Debug_Log_Schedulable', 
                                       '0 0 4 * * ?', 
                                       new SPWR_Spectrum_Debug_Log_Schedulable());
        Test.stopTest();

        //check the schedule details
        List<CronTrigger> cronJob = [SELECT Id, CronExpression,
                                            TimesTriggered, NextFireTime
                                     FROM CronTrigger
                                     WHERE (Id = :jobId)];

        if (!cronJob.isEmpty()) {
            CronTrigger schedJob = cronJob.get(0);
            System.assert(schedJob.CronExpression.equals('0 0 4 * * ?'));
            System.assert(schedJob.TimesTriggered == 0);
            System.assert(schedJob.NextFireTime.hour() == 4);
        }
    }
}
/*****
=============
CLASS DETAILS
=============
Class Name: SPWR_Spectrum_Debug_Log_Batchable_Test
Author: Kane Chelster Macaspac

Description:
This is a test class for SPWR_Spectrum_Debug_Log_Batchable.  As reference, the batch class is supposed to delete records that match
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
private class SPWR_Spectrum_Debug_Log_Batchable_Test {
    static testMethod void testBatchRun() {
        List<Sunpower_Spectrum_Debug_Log__c> ssdl = SPWR_Spectrum_Debug_Log_TestDataFactory.generateSSDL();
    
        insert ssdl;
    
        Test.startTest();
        Database.executeBatch(new SPWR_Spectrum_Debug_Log_Batchable());
        Test.stopTest();
    
        ssdl = [SELECT Id 
                FROM Sunpower_Spectrum_Debug_Log__c
                WHERE (Service__c LIKE 'SO %' AND CreatedDate < LAST_N_DAYS:45) OR
                       (Service__c = 'SPD Lead/Five9 Web2Campaign' AND CreatedDate < LAST_N_DAYS:45) OR
                       (Service__c = 'GeoCallOut to Google' AND CreatedDate < LAST_N_DAYS:15) OR
                       (((NOT Service__c LIKE '%Mosaic%') AND (NOT Service__c LIKE '%Agreement%')) 
                        AND CreatedDate < LAST_N_DAYS:180)];
                
        System.assertEquals(ssdl.size(), 0, 'List size is ' + ssdl.size());
    }    
    
    static testMethod void testBatchRun_EmptyList() {
        List<Sunpower_Spectrum_Debug_Log__c> ssdl = new List<Sunpower_Spectrum_Debug_Log__c>();
    
        Test.startTest();
        Database.executeBatch(new SPWR_Spectrum_Debug_Log_Batchable());
        Test.stopTest();
    
        ssdl = [SELECT Id 
                FROM Sunpower_Spectrum_Debug_Log__c
                WHERE (Service__c LIKE 'SO %' AND CreatedDate < LAST_N_DAYS:45) OR
                       (Service__c = 'SPD Lead/Five9 Web2Campaign' AND CreatedDate < LAST_N_DAYS:45) OR
                       (Service__c = 'GeoCallOut to Google' AND CreatedDate < LAST_N_DAYS:15) OR
                       (((NOT Service__c LIKE '%Mosaic%') AND (NOT Service__c LIKE '%Agreement%')) 
                        AND CreatedDate < LAST_N_DAYS:180)];
    
        System.assertEquals(ssdl.size(), 0, 'List size is ' + ssdl.size());
    }
}
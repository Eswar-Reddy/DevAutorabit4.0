/*****
=============
CLASS DETAILS
=============
Class Name: SPWR_Spectrum_Debug_Log_Batchable
Author: Kane Chelster Macaspac
Test Class: SPWR_Spectrum_Debug_Log_Batchable_Test

Description:
This class will run a batch job that would delete certain 
SunPower Spectrum Debug Log records based on the following criteria:

1. Service__c starts with SO and older than 45 days
2. Service__c is SPD Lead/Five9 Web2Campaign and older than 45 days
3. Service__c is GeoCallOut to Google and older than 15 days
4. All other services older than 180 days that does not contain Mosaic or Agreement 

This batch can be scheduled through the SPWR_Spectrum_Debug_Log_Schedulable class.


==============
CHANGE HISTORY
==============
Version: n/a
Author: n/a
Last Modified Date/Time: n/a
Details: n/a

*****/

global class SPWR_Spectrum_Debug_Log_Batchable implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id 
                                      FROM Sunpower_Spectrum_Debug_Log__c
                                      WHERE (Service__c LIKE 'SO %' AND CreatedDate < LAST_N_DAYS:45) OR
                                            (Service__c = 'SPD Lead/Five9 Web2Campaign' AND CreatedDate < LAST_N_DAYS:45) OR
                                            (Service__c = 'GeoCallOut to Google' AND CreatedDate < LAST_N_DAYS:15) OR
                                            (((NOT Service__c LIKE '%Mosaic%') AND (NOT Service__c LIKE '%Agreement%')) 
                                              AND CreatedDate < LAST_N_DAYS:180)]);
    }

    global void execute(Database.BatchableContext bc,
                List<Sunpower_Spectrum_Debug_Log__c> scope){
        if (scope.size() > 0) {
            delete scope;
        }
    }

    global void finish(Database.BatchableContext bc){
        System.debug('Finished Execution: ' + System.now().format());
    }
}
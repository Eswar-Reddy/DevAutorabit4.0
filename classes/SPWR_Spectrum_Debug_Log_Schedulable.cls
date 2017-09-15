/*****
=============
CLASS DETAILS
=============
Class Name: SPWR_Spectrum_Debug_Log_Schedulable
Author: Kane Chelster Macaspac
Test Class: SPWR_Spectrum_Debug_Log_Schedulable_Test

Description:
This class will allow to schedule the batch SPWR_Spectrum_Debug_Log_Batchable
to delete certain SunPower Spectrum Debug Log records based on the following criteria:

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

global class SPWR_Spectrum_Debug_Log_Schedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new SPWR_Spectrum_Debug_Log_Batchable());
    }
}
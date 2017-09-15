/*****
=============
CLASS DETAILS
=============
Class Name: SPWR_Spectrum_Debug_Log_TestDataFactory
Author: Kane Chelster Macaspac

Description:
This is a data factory class used by SPWR_Spectrum_Debug_Log_Schedulable_Test and SPWR_Spectrum_Debug_Log_Batchable_Test test classes.

==============
CHANGE HISTORY
==============
Version: n/a
Author: n/a
Last Modified Date/Time: n/a
Details: n/a

*****/


@isTest
public class SPWR_Spectrum_Debug_Log_TestDataFactory {
    public static List<Sunpower_Spectrum_Debug_Log__c> generateSSDL(){
        Date d = Date.Today();
    
        List<Sunpower_Spectrum_Debug_Log__c> temp = new List<Sunpower_Spectrum_Debug_Log__c>();
        
        //must be deleted by the batch class since Service__c starts with an SO and is more than 45 days old
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'SO Service Log 1', 
                                                    Service__c = 'SO Get Orders', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-46)));
                                                   
        //must not be deleted by the batch class since Service__c starts with an SO but is less than 45 days old
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'SO Service Log 2', 
                                                    Service__c = 'SO Update Orders', 
                                                    CurrencyISOCode  = 'USD',
                                                    CreatedDate = d.addDays(-40)));
                                                    
        //must not be deleted by the batch class since Service__c contains 'Mosaic'
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Mosaic Log 1', 
                                                    Service__c = 'Mosaic Create Opportunity', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-180)));
                                                    
        //must not be deleted by the batch class since the Service__c contains 'Agreement'
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Agreement Log 1', 
                                                    Service__c = 'Agreement Update Service', 
                                                    CurrencyISOCode  = 'USD',
                                                    CreatedDate = d.addDays(-45)));
        
        //must be deleted by the batch class since the Service__c is 'GeoCallOut to Google' and is more than 15 days old
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Geo Log 1', 
                                                    Service__c = 'GeoCallOut to Google', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-45)));  

        //must not be deleted by the batch class since the Service__c is 'GeoCallOut to Google' but less than 15 days old                                     
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Geo Log 2', 
                                                    Service__c = 'GeoCallOut to Google', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-5)));   
                                                    
        //must be deleted by the batch class since the Service__c is 'SPD Lead/Five9 Web2Campaign' and is 45 days old                                    
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Five9 Log 1', 
                                                    Service__c = 'SPD Lead/Five9 Web2Campaign', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-45)));  

        //must not be deleted by the batch class since the Service__c is 'SPD Lead/Five9 Web2Campaign' but is less than 45 days old
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Five9 Log 2', 
                                                    Service__c = 'SPD Lead/Five9 Web2Campaign', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-5)));                                                     

        //must be deleted by the batch class since the Service__c does not contain 'Mosaic' nor 'Agreement' and is more than 180 days old
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Random Log 1', 
                                                    Service__c = 'Some Random Service', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-205)));                                                                                                       
                                                    
        //must not be deleted by the batch class since the Service__c does not contain 'Mosaic' nor 'Agreement' but is less than 180 days old
        temp.add(new Sunpower_Spectrum_Debug_Log__c(Name = 'Random Log 2', 
                                                    Service__c = 'Some Random Service', 
                                                    CurrencyISOCode = 'USD',
                                                    CreatedDate = d.addDays(-25)));   
                                                                                                
        return temp;                                       
    }
}
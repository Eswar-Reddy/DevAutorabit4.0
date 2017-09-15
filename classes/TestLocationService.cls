/*********************************************************************
Name :  TestLocationService
Created On : June 6, 2011  
Created By : Bharti Mehta(Appirio)
Description :Testclass for LocationService
History: 1.0 Created   
**********************************************************************/

@isTest
private class TestLocationService{
    static String LOCNAME1 = 'ABC';
    static String LOCNAME2 = 'ABC2';
    
    static testmethod void unitTest(){
        prepareTestData();
        
        //test start
        Test.startTest();
        LocationService instance = LocationService.getInstance();
        Location__c loc1 = instance.findLocationByName(LOCNAME1);
        Location__c loc2 = instance.findLocationByName(LOCNAME2);        
        
        Set<String> locNames = instance.findLocationNamesWithinMileRadius(LOCNAME1,null);
        system.assertEquals(2,locNames.size()); //MAM 05.MAR.2015 Case 00407201 modify the Assert Result
        
        try{
            locNames = instance.findLocationNamesWithinMileRadius('dumy',5);
        }catch(Exception e){
            system.assert(true);
        }
        
        Decimal distance1 = instance.computeDistance(loc1,loc2);
        Decimal distance2 = instance.computeDistance(LOCNAME1,LOCNAME2);
        if(distance2 > 0)
              system.assert(true);
                
        Test.stopTest();
        //test end
    }


    static void prepareTestData(){
        List<Location__c> locations = new List<Location__c>();
        
        Location__c loc = new Location__c();
        loc.Name = LOCNAME1;
        loc.Latitude__c = 10;
        loc.Longitude__c = 10;
        locations.add(loc);
        
        loc = new Location__c();
        loc.Name = LOCNAME2;
        loc.Latitude__c = 11;
        loc.Longitude__c = 11;
        locations.add(loc);
        
        insert locations;
    }
}
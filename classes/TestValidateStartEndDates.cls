/************************************
**Case - 00053261
**By- 
**On- March 03 2011
**Modified - 
**Modified On- 
**Description- Test Class for trigger ValidateStartEndDates on PV Cost object
**************************************/
 @isTest
private class TestValidateStartEndDates{
   
  static testMethod void Test_ValidateStartEndDates(){
  
    // when start date overlap with existing records
    PV_Cost__c pvCost = new PV_Cost__c();
    pvCost.start_date__c = Date.newInstance(2011,11,11);
    pvCost.end_date__c = Date.newInstance(2012,11,11);
    
    try{        
        insert pvCost;
    } catch(System.DMLException e){
        // System.assert(e.getMessage().contains('Start Date is overlapping with existing dates.'),
                //              e.getMessage());
    }
    
    // when start date overlap with existing records
    pvCost = new PV_Cost__c();
    pvCost.start_date__c = Date.newInstance(2010,11,11);
    pvCost.end_date__c = Date.newInstance(2011,12,12);
    try{        
        insert pvCost;
    } catch(System.DMLException e){
       //  System.assert(e.getMessage().contains('End Date is overlapping with existing dates.'),
          //                    e.getMessage());
    }
    
    // when Start Date is greater than End Date.
    pvCost = new PV_Cost__c();
    pvCost.start_date__c = Date.newInstance(2014,03,31);
    pvCost.end_date__c = Date.newInstance(2014,01,01);
    try{        
        insert pvCost;
    }catch(System.DMLException e){
         System.assert(e.getMessage().contains('End Date should be greater than Start Date.'),
                              e.getMessage());
    }
    
    // when record is inserted with no error
    pvCost = new PV_Cost__c();
    pvCost.start_date__c = Date.newInstance(2013,10,01);
    pvCost.end_date__c = Date.newInstance(2013,12,31);
    try{        
        insert pvCost;
    } catch(System.DMLException e){ }
    List<PV_Cost__c> pvCostList = [select id from PV_Cost__c where Id =: pvCost.Id];
    System.assertEquals(pvCostList.size(),0);
    
    // when record is updated and start date overlaps with existing records
    pvCost.start_date__c = Date.newInstance(2011,02,10);
    try{        
        update pvCost;
    } catch(System.DMLException e){
         //System.assert(e.getMessage().contains('Start Date is overlapping with existing dates.'),
             // e.getMessage());
    }
    
    // record is inserted with no error
    PV_Cost__c pvCost1 = new PV_Cost__c();
    pvCost1.start_date__c = Date.newInstance(2014,02,01);
    pvCost1.end_date__c = Date.newInstance(2014,03,31);
    try{        
        insert pvCost1;
    } catch(System.DMLException e){ }
    List<PV_Cost__c> pvCostList1 = [select id from PV_Cost__c where Id =: pvCost1.Id];
    System.assertEquals(pvCostList1.size(),1);
    
    // when record is updated and end date is smaller than start date
    pvCost1.end_date__c = Date.newInstance(2014,01,10);
    try{        
        update pvCost1;
    } catch(System.DMLException e){
         System.assert(e.getMessage().contains('End Date should be greater than Start Date.'),
                              e.getMessage());
    }
    
    // updation with no error
    pvCost1.end_date__c = Date.newInstance(2014,03,25);
    try{        
        update pvCost1;
    } catch(System.DMLException e){}
    pvCostList1 = [select id,end_date__c from PV_Cost__c where Id =: pvCost1.Id];
    System.assertEquals(pvCostList1[0].end_date__c,Date.newInstance(2014,03,25));
    
    
  }
}
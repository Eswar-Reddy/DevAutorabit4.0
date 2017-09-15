/*******************************************************************
    Name        :   WR_BatchUpdateAsset_Test
    Author      :   Appirio Offshore(Anjali Khandelwal)
    Version     :   1.0
    Purpose     :   Test class for WR_BatchUpdateAsset
    Related PR  :   
    Date        :   Sept 21, 2011
*******************************************************************/
@isTest
private class WR_ScheduleBatch_Test {

    static testMethod void WR_ScheduleBatchTest() {
       
        
        //Create schedule string
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        
        Test.startTest();
        
        WR_ScheduleBatch schCls = new WR_ScheduleBatch();
        
        // Schedule the test job
        String jobId = system.schedule('Process Assets', sch, schCls);
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(sch, ct.CronExpression);
        
        // Verify the job has not run  
      	System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run  
      	System.assert(ct.NextFireTime > DateTime.now());
        
        Test.stopTest();
    }
    
   
}
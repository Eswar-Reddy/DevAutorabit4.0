trigger afterSunriseMetricInsert on Metric__c (after insert) {      
     SunriseMetricManagement.afterSunriseMetricInsert(Trigger.NewMap);    
}
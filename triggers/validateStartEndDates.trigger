/*
It is used to validate the start and end dates of PV cost object.
The dates should not overlap with the previous range.
End Date should be greater than Start Date.
Creation Date : 15 Feb 2011
Related Case : 00053261
*/

trigger validateStartEndDates on PV_Cost__c (before insert ,before update) {

  Set<Id> pvcIdSet = new Set<Id>();
  for(PV_Cost__c pvcost : Trigger.new){
    pvcIdSet.add(pvcost.id);
  }
  List<PV_Cost__c> PVcostList = [select start_date__c , end_date__c from PV_Cost__c where Id NOT IN: pvcIdSet];
  for(PV_Cost__c pvcost : Trigger.new){
    for(PV_Cost__c pvc : PVcostList){
      if(pvcost.start_date__c >= pvc.start_date__c && pvcost.start_date__c <= pvc.end_date__c){
         pvcost.start_date__c.addError('Start Date is overlapping with existing dates.');         
      }else if(pvcost.end_date__c >= pvc.start_date__c && pvcost.end_date__c <= pvc.end_date__c){
         pvcost.end_date__c.addError('End Date is overlapping with existing dates.');
      }   
    }
    if(pvcost.end_date__c <= pvcost.start_date__c){
      pvcost.end_date__c.addError('End Date should be greater than Start Date.');
    }
  }
    
}
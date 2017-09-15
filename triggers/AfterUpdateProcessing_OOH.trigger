//Trigger to update status field from order to order Change object
trigger AfterUpdateProcessing_OOH on oe_order_headers__c (after Update)
{ 
    Set<String> sSFDCRId = new Set<String>();  
     
    for(oe_order_headers__c ord : Trigger.New){    
        if(ord.SFDC_REQUEST_ID__c != null && ord.SFDC_REQUEST_STATUS__c != trigger.oldMap.get(ord.Id).SFDC_REQUEST_STATUS__c)
            sSFDCRId.add(ord.SFDC_REQUEST_ID__c);
    }

    if(!sSFDCRId.isEmpty())
    {
        Map<String, ORDER_Change_REQUESTS__c> mOCR = new Map<String, ORDER_Change_REQUESTS__c>();
        Map<Id, Integer> lstOCRCounter = new Map<Id, Integer>();
        for(oe_order_headers__c ord: [SELECT id, 
                                             (SELECT id, Look_up_order__c, Counter__c,
                                                     SFDC_Request_Status__c, Name 
                                              FROM Order_change__r 
                                              ORDER BY CreatedDate ASC)
                                      FROM oe_order_headers__c 
                                      WHERE SFDC_REQUEST_ID__c IN: sSFDCRId])
        {
            List<ORDER_Change_REQUESTS__c> tlstOCR = ord.Order_change__r;
SYSTEM.DEBUG('--1--> ' + tlstOCR.size() + '\n' + tlstOCR);          
            if(tlstOCR != null && !tlstOCR.isEmpty())
            {
                Integer iCount = 1;
                for(ORDER_Change_REQUESTS__c tOCR: tlstOCR){
SYSTEM.DEBUG('--1.1--> ' + tOCR);               
                    mOCR.put(tOCR.Name, tOCR);
                    lstOCRCounter.put(tOCR.id, iCount);
                    iCount++;                   
                }
            }
SYSTEM.DEBUG('--2--> ' + lstOCRCounter.size() + '\n' + lstOCRCounter);              
        }
        //for(ORDER_Change_REQUESTS__c ocr: [select id, Look_up_order__c, 
        //                                          SFDC_Request_Status__c, Name 
        //                                   from ORDER_Change_REQUESTS__c 
        //                                   where Name IN: sSFDCRId]){
        //    mOCR.put(ocr.Name, ocr);
        //}
        
        if(!mOCR.isEmpty())
        {
            List<ORDER_Change_REQUESTS__c> lstOCRtoUpdate = new List<ORDER_Change_REQUESTS__c>();           
            for(oe_order_headers__c ord1 : Trigger.New){
                if(String.isNotBlank(ord1.SFDC_REQUEST_ID__c) && mOCR.containskey(ord1.SFDC_REQUEST_ID__c)){
                    if(lstOCRCounter.containsKey(mOCR.get(ord1.SFDC_REQUEST_ID__c).Id)){
                        Integer iCtemp = lstOCRCounter.remove(mOCR.get(ord1.SFDC_REQUEST_ID__c).Id);
                        lstOCRtoUpdate.add(new ORDER_Change_REQUESTS__c(id= mOCR.get(ord1.SFDC_REQUEST_ID__c).Id, 
                                                                        SFDC_Request_Status__c= ord1.SFDC_REQUEST_STATUS__c,
                                                                        Counter__c= iCtemp));
                        
                    }                                                                  
                }
            } 
            if(!lstOCRCounter.isEmpty())
            {
                for(Id ids: lstOCRCounter.keySet())
                    lstOCRtoUpdate.add(new ORDER_Change_REQUESTS__c(id= ids,
                                                                    Counter__c= lstOCRCounter.get(ids)));
            }           
System.debug('--3--> ' + lstOCRtoUpdate);           
            if(!lstOCRtoUpdate.isEmpty())
                update lstOCRtoUpdate;
        }                
    }   
}
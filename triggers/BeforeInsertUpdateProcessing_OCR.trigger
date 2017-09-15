trigger BeforeInsertUpdateProcessing_OCR on Order_Change_Requests__c (before Insert , before update) 
{
    Integer recordsAllowed = (Order_Change_Requests_Setting__c.getInstance('Allowed Requests') != null && Order_Change_Requests_Setting__c.getInstance('Allowed Requests').Allowed_Order_Change_Requests__c != null) 
                              ? Integer.valueOf(Order_Change_Requests_Setting__c.getInstance('Allowed Requests').Allowed_Order_Change_Requests__c) 
                              : 0;
    List<oe_order_headers__c> Ordhdr = new List<oe_order_headers__c>(); //Order Object
    
    Set<Id> setOrder = new Set<Id>(); //Unique Orders 
    for(Order_Change_Requests__c crdchange : Trigger.new)
        if(crdchange.Look_up_order__c != null)
            setOrder.add(crdchange.Look_up_order__c);
            
    Map<Id, oe_order_headers__c> mOOH = new Map<Id, oe_order_headers__c>(); 
    if(!setOrder.isEmpty()){
        mOOH = new map<Id, oe_order_headers__c>([SELECT id, 
                                                       (SELECT id, SFDC_Request_Status__c  
                                                        FROM Order_change__r) 
                                                FROM oe_order_headers__c 
                                                WHERE id IN: setOrder]);
    }
    
    for(Order_Change_Requests__c crdchange : Trigger.new)
    {
        if(Trigger.isBefore && Trigger.isInsert){
            crdchange.SFDC_Request_Status__c = 'Pending';
            if(crdchange.Look_up_order__c != null && mOOH.containsKey(crdchange.Look_up_order__c)){
                Integer recordsCreated = 0;
                List<Order_Change_Requests__c> lstOCR = mOOH.get(crdchange.Look_up_order__c).Order_change__r;
                
                Map<String, Integer> mStatusCounts = new Map<String, Integer>{'Pending'=>0, 'Approved'=>0, 'Rescheduled'=>0};
                if(lstOCR != null && !lstOCR.isEmpty()){
                    for(Order_Change_Requests__c ocr: lstOCR){
                        if(ocr.SFDC_Request_Status__c == 'Pending')
                            mStatusCounts.put('Pending', mStatusCounts.get('Pending') + 1);
                        else if(ocr.SFDC_Request_Status__c == 'Approved')
                            mStatusCounts.put('Approved', mStatusCounts.get('Approved') + 1);
                        else if(ocr.SFDC_Request_Status__c == 'Rescheduled')
                            mStatusCounts.put('Rescheduled', mStatusCounts.get('Rescheduled') + 1);                                 
                    }
                }
                for(String s : mStatusCounts.keySet())
                    recordsCreated += mStatusCounts.get(s);
                                 
                //THROW ERROR if below BUSINESS CONDITIONS MEET
                //if(recordsCreated >= recordsAllowed)
                    //crdchange.addError(String.valueOf(recordsCreated) + ' CRD Date Request records are already created! Allowed limit is: ' + String.valueOf(recordsAllowed) + '.');
                if(lstOCR != null && mStatusCounts.containsKey('Pending') && mStatusCounts.get('Pending') > 0)
                    crdchange.addError('There exists a record with \'Pending\' status. You can not create new reocrd .');// status \'Pending\'.');
            }
        }
    }
}
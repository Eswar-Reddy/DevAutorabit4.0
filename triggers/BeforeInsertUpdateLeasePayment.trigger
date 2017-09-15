trigger BeforeInsertUpdateLeasePayment on LeasePayment__c (before insert, before update) 
{
    List<Id> lstQId = new List<Id>();
    for(LeasePayment__c lp: Trigger.new)
        if(lp.Quote__c != null)
            lstQId.add(lp.Quote__c);
            
    if(!lstQId.isEmpty())
    {
        Map<Id, Quote> mapQ = new Map<Id, Quote>([SELECT id, Lessee__r.Email, 
                                                         Oracle_Vendor_Email__c,
                                                         Oracle_Vendor_email_field_value__c 
                                                  FROM Quote 
                                                  WHERE id IN: lstQId]);
        for(LeasePayment__c lp: Trigger.new)
        {
            if(lp.Quote__c != null && mapQ.containsKey(lp.Quote__c)){
                lp.Partner_Oracle_Vendor_Email__c = mapQ.get(lp.Quote__c).Oracle_Vendor_Email__c;
                lp.Lessee_Email__c = mapQ.get(lp.Quote__c).Lessee__r.Email;
            }
        }
    }

}
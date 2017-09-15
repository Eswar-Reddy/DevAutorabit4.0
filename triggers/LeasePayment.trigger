/*
Modification:
12-Dec-2013 : Sandesh Birlasoft
4-Jun-2014 : Birlasoft : Only Added Debug Statements
*/
trigger LeasePayment on LeasePayment__c (after insert, after update, before update, before insert) {
    if(trigger.isAfter) {
        if ( !LeasePaymentService.hasRun ) {
            //LeasePaymentService.createLeaseScheduleSummary( Trigger.newMap , Trigger.oldMap );
        }
        if(trigger.isInsert) {
            LeasePaymentService.createInvoiceDocuments(trigger.new);
        }
        if(trigger.isUpdate) {

            Set<Id> oppIdSet = new Set<Id>();

            for(LeasePayment__c lpynew: Trigger.new)
            {
               for(LeasePayment__c lpyold: Trigger.old){
                
                    if(lpynew.Id == lpyold.Id && lpynew.Opportunity__c != null && lpynew.Placed_In_Service__c != null && lpynew.Placed_In_Service__c != lpyold.Placed_In_Service__c)
                     oppIdSet.add(lpynew.Opportunity__c);
                    
               }
            }

            List<Opportunity> lstopp = new  List<Opportunity> ();
            if(!oppIdSet.isEmpty()){
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([select id,Lease_Placed_in_Service__c from Opportunity where id in :oppIdSet]);

            for(LeasePayment__c lp : Trigger.new)
               {
                if(oppMap.get(lp.Opportunity__c) == null)
                    continue;
                else
                 if(lp.Placed_In_Service__c != null )
                    {
                        lstopp.add(new Opportunity(id = oppMap.get(lp.Opportunity__c).Id,Lease_Placed_in_Service__c = true,StageName = 'Installation Completed'));
                        System.debug('#4' + lstopp);
                    }
               }

                if(!lstopp.isEmpty())
                  Update lstopp;
                  System.debug('#5' + lstopp);
            }
             
             // Co Branding
            Set<Id> accIdSet = new Set<Id>();
            List<Account> tempList = new List<Account>();           
            for(LeasePayment__c lpynew: Trigger.new)
            {
                if(lpynew.Funding_Tranche__c<>'ConEdison Solutions' && Trigger.oldMap.get(lpynew.Id).Funding_Tranche__c <> lpynew.Funding_Tranche__c && Trigger.oldMap.get(lpynew.Id).Funding_Tranche__c=='ConEdison Solutions'){
                    accIdSet.add(lpynew.Account__c);
                    system.debug('**** in co branding  1');
                    
                }
               
               
            }
            if( accIdSet.size()>0){
                
                For( Account a : [Select Id,CO_BRAND_Partner__c from Account where ID in :accIdSet and CO_BRAND_Partner__c <> null and  CO_BRAND_Partner__c <> '']){
                    
                    a.CO_BRAND_Partner__c ='';
                    tempList.add(a);
                    system.debug('**** in co branding  2');
                    
                    
                }
            }
            if(tempList.size()>0){
                update tempList;
                system.debug('**** in co branding  3');
                
            }
            
        }
    }

    if(trigger.isupdate) {
        

        Select.Filter statusFilter = Select.Field.hasChanged( LeasePayment__c.Status__c).andx( Select.Field.isEqual(LeasePayment__c.Status__c, LeasePaymentService.STATUS_VALUE) );
        Select.Filter checkboxFilter = Select.Field.hasChanged( LeasePayment__c.Run_Invoice_Documents_Trigger__c).andx( Select.Field.isEqual(LeasePayment__c.Run_Invoice_Documents_Trigger__c, true) );

        List<LeasePayment__c> filteredLeases = statusFilter.orx( checkboxFilter ).filter( Trigger.new, Trigger.oldMap );

        if(trigger.isBefore){
            //LeasePaymentService.applyFMVRate(Trigger.new, Trigger.oldMap);
            LeasePaymentService.populateInstallAndInterconnect(filteredLeases);
            for(LeasePayment__c leasePayment : filteredLeases)
           {
                leasePayment.Run_Invoice_Documents_Trigger__c = false;
            }
        }
        if(trigger.isAfter) LeasePaymentService.createInvoiceDocuments(filteredLeases);
    }

    if(trigger.isInsert && trigger.isBefore) {
        List<LeasePayment__c> filteredLeases = Select.Field.isEqual(LeasePayment__c.Status__c, LeasePaymentService.STATUS_VALUE).filter( Trigger.new );
        System.debug('$$$ Inside Trigger Before populate Method Call, Size of filteredLeases '+filteredLeases.size());
        LeasePaymentService.populateInstallAndInterconnect(filteredLeases);
            

        //30-Jan-2017 : Sita Reeves : Connect FPO to Residential Project
        //When FPO is created, try to link it to a Res Project through Quote
        Map<Id, LeasePayment__c> quoteMap = new Map<Id, LeasePayment__c>();
        for(LeasePayment__c lp : Trigger.New){
            if(lp.Quote__c != NULL)quoteMap.put(lp.Quote__c, lp);
        }
        if(quoteMap.size() > 0) LeasePaymentService.connectFPOtoRP(quoteMap);
    }

}
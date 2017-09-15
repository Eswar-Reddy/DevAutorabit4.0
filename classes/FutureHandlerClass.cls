public class FutureHandlerClass {
    @future
    public static void checkSigned(Set<Id> sAIds) {
        List<Quote> lstQ = new List<Quote>();
        Set<Id> setQId = new Set<Id>();
        Set<Id> setQId2 = new Set<Id>();
        Id amendmentRecTypeId = AgreementUtility.amendmentRecTypeId;
        Map<Id, Id> mapAggLPId = new Map<Id, Id>();
        List<LeasePayment__c> listStatusChange = new List<LeasePayment__c>();

        if(!sAIds.isEmpty()) {
            for(LeasePayment__c lp : [SELECT Id, Name, Status__c, Quote__c, Agreement__c, Opportunity__c, Account__c FROM LeasePayment__c WHERE Agreement__c IN: sAIds]) {
                mapAggLPId.put(lp.Agreement__c, lp.Id);
            }

            for(echosign_dev1__SIGN_Agreement__c agr : [SELECT Id, Name, RecordType.DeveloperName, Agreement_Name__c, Agg_created_through__c, Quote__c, echosign_dev1__Status__c, echosign_dev1__DateSigned__c, RecordTypeId, Change_Order_Type__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id IN : sAIds]) {
                // check for quote
                if(String.isNotBlank(agr.Quote__c)) {
                    String status = agr.echosign_dev1__Status__c;
                    Date dateSigned;
                    if(agr.echosign_dev1__DateSigned__c != null) dateSigned = Date.newInstance(agr.echosign_dev1__DateSigned__c.year(), agr.echosign_dev1__DateSigned__c.month(), agr.echosign_dev1__DateSigned__c.day());

                    // check agreement status
                    if(dateSigned != null && status == 'Signed' && (agr.Name.contains('Lease') || agr.Agreement_Name__c.contains('Lease') || agr.Name.contains('Cash') || agr.Agreement_Name__c.contains('Cash') || agr.RecordType.DeveloperName == 'Lending_Agreement')) {

                        lstQ.add(new Quote(
                            Id = agr.Quote__c,
                            Lease_Doc_Signed__c = true,
                            Lease_doc_Signed_Date__c = dateSigned
                            )
                        );
                        setQId.add(agr.Quote__c);
                    }

                    if(status == 'Signed' && agr.RecordTypeId == amendmentRecTypeId && agr.Change_Order_Type__c != 'Economic Amendment') {
                        lstQ.add(new Quote(
                            Id = agr.Quote__c,
                            Amendment_Doc_Signed__c = true
                            )
                        );
                    }

                    if(status == 'Out for Signature' && (agr.Name.contains('Lease') || agr.Agreement_Name__c.contains('Lease'))) {
                        lstQ.add(new Quote(Id = agr.Quote__c,
                        	Doc_out_for_signature__c = true
                        	)
                        );
                    }

                    if(status == 'Draft') {
                        lstQ.add(new Quote(Id = agr.Quote__c,
                        	Lease_Doc_Created__c = true
                        	)
                        );
                    }

                    if(status == 'Signed' && (agr.Name.contains('Termination') || agr.Agreement_Name__c.contains('Termination'))) {
                        lstQ.add(new Quote(
                            Id = agr.Quote__c,
                            Lease_Doc_Terminated__c = true
                            )
                        );
                        setQId2.add(agr.Quote__c);
                    }

                    if(status == 'Signed' && agr.Agg_created_through__c == 'LOI' && !mapAggLPId.isEmpty()) {
                        listStatusChange.add(new LeasePayment__c(
                        	Id = mapAggLPId.get(agr.Id),
                        	Status__c = 'Active'
                        	)
                        );
                    }
                }
            }
        }
        if(!lstQ.isEmpty()) update lstQ;
        if(!listStatusChange.isEmpty()) update listStatusChange;

        // Tp update Quote Suammary field - 'Lease Doc Signed'
        List<Quote_Summary__c> lstQS = new List<Quote_Summary__c>();
        if(!setQId.isEmpty() || !setQId2.isEmpty()) {
            for(Quote q: [SELECT Id, Quote_Summary__c,Lease_Doc_Signed__c, Lease_Doc_Terminated__c FROM Quote WHERE Id IN : setQId OR Id IN : setQId2]) {
                if(setQId.contains(q.Id) && q.Lease_Doc_Signed__c == true) {
                    if(q.Quote_Summary__c != null) {
                        lstQS.add(new Quote_Summary__c(Id = q.Quote_Summary__c, Lease_Doc_Signed__c = true));
                    }
                }
                // If the termination doc is counter signed, then update the Lease_Doc_Terminated__c on Quote Summary
                if(setQId2.contains(q.Id) && q.Lease_Doc_Terminated__c == true && q.Quote_Summary__c != null) {
                    lstQS.add(new Quote_Summary__c(Id = q.Quote_Summary__c, Lease_Doc_Terminated__c = true));
                }
            }
        }
        if(!lstQS.isEmpty()) update lstQS;
    }

    @future
    public static void CheckSignednew_FR(Set<Id> SetIdEchoSIghRec) {
        if(!SetIdEchoSIghRec.isEmpty()) {
            List<LeasePayment__c> listLP = new List<LeasePayment__c>();
            for(LeasePayment__c lp : [SELECT Id, Name, Status__c, Quote__c, Opportunity__c, Account__c FROM LeasePayment__c WHERE Agreement__c IN: SetIdEchoSIghRec]) {
                lp.Status__c = 'Active';
                listLP.add(lp);
            }
            if(!listLP.isEmpty()) update listLP;
        }
    }
}
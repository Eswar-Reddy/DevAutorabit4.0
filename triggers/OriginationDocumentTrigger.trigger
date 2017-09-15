trigger OriginationDocumentTrigger on Origination_Document__c (after update) {
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            List<Origination_Document__c> approvedOriginationDocs = Select.Field.hasChanged(Origination_Document__c.Status__c).
            andx(Select.Field.isEqual(Origination_Document__c.Status__c, InvoiceDocumentServices.APPROVED)).
            andx(Select.Field.isEqual(Origination_Document__c.Not_Required_for_Approval__c, false)).filter(Trigger.new, Trigger.oldMap);
            if(!approvedOriginationDocs.isEmpty())
            {
                OriginationDocumentServices.setApprovedField(approvedOriginationDocs);
            }

            List<Origination_Document__c> previouslyApprovedOriginationDocs = Select.Field.isEqual(Origination_Document__c.Status__c, InvoiceDocumentServices.APPROVED).filter(Trigger.old);
            List<Id> previouslyApprovedDocIds = new List<Id>(Pluck.ids(previouslyApprovedOriginationDocs));

            List<Origination_Document__c> unApprovedDocs = Select.Field.hasChanged(Origination_Document__c.Status__c).
            andx(Select.Field.notEqual(Origination_Document__c.Status__c, InvoiceDocumentServices.APPROVED)).
            andx(Select.Field.isEqual(Origination_Document__c.Not_Required_for_Approval__c, false)).
            andx(Select.Field.isIn(Origination_Document__c.Id, previouslyApprovedDocIds)).filter(Trigger.new, Trigger.oldMap);

            if(!unApprovedDocs.isEmpty())
            {
                OriginationDocumentServices.removeApprovedField(unApprovedDocs);
            }
        }
    }
}